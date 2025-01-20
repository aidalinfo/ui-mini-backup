<template>
  <div v-if="loading" class="q-pa-md">
    <q-spinner size="md" color="primary" />
  </div>
  <div v-else class="q-pa-md">
    <card-layout color="primary">
      <template #header>
        <div class="text-h5">Liste des backups</div>
      </template>
      <template #content>
        <q-table
        ></q-table>
      </template>
    </card-layout>
  </div>
</template>



<script setup>
import CardLayout from 'src/layouts/CardLayout.vue';
// import NotificationBox from './NotificationBox.vue';
// Références
const $q = useQuasar();
const data = ref(null);
const rows = ref([]);
const loading = ref(true);
const pagination = ref({
  page: 1,
  rowsPerPage: 10,
});
// Fonction pour charger les données
async function loadData() {
  try {
    const response = await api.get('/api/backups/all');
    data.value = response.data.backup;
    $q.notify({
      color: 'positive',
      position: 'top',
      message: 'Données chargées avec succès!',
      icon: 'done',
    });
  } catch (error) {
    $q.notify({
      color: 'negative',
      position: 'top',
      message: 'Erreur lors du chargement des données: ' + error.message,
      icon: 'report_problem',
    });
  } finally {
    loading.value = false;
  }
}

// Colonnes pour le tableau
const columns = [
  {
    name: 'name',
    required: true,
    label: 'Nom',
    align: 'left',
    field: row => row.name,
    format: val => `${val}`,
    sortable: true,
  },
  {
    name: 'type',
    required: true,
    label: 'Type',
    align: 'left',
    field: row => row.Type,
    format: val => `${val}`,
    sortable: true,
    icon: 'storage',
  },
  {
    name: 'stockage-distant',
    required: true,
    label: 'Stockage S3',
    align: 'left',
    field: row => row.Path.S3,
    format: val => `${val}`,
    sortable: true,
    icon: 'cloud',
  },
  {
    name: 'cron-standard',
    required: true,
    label: 'Cron Standard',
    align: 'left',
    field: row => row.Schedule.Standard,
    format: val => `${val}`,
    sortable: true,
  },
  {
    name: 'action',
    required: false,
    label: 'Actions',
    align: 'center',
  },
];

// Mettre à jour `rows` lorsque `data` change
watch(data, (newValue) => {
  if (newValue) {
    rows.value = Object.keys(newValue).map((key) => ({
      name: key,
      ...newValue[key],
    }));
  }
});

async function listLastBackup() {
  const response = await api.get(`/api/backups/${selectedBackup.value.name}/files`);
  if (response.status === 200) {
    const files = response.data.files;

    // Trier les fichiers par ordre décroissant
    const sortedFiles = files.sort().reverse();

    // Obtenir les trois derniers
    filesListed.value = sortedFiles.slice(0, 3);

    $q.notify({
      color: 'positive',
      position: 'top',
      message: `Liste des fichiers de la dernière sauvegarde pour ${selectedBackup.value.name}`,
    });
  } else {
    $q.notify({
      color: 'negative',
      position: 'top',
      message: `Erreur lors de la récupération des fichiers de la dernière sauvegarde pour ${selectedBackup.value.name}`,
    });
  }
}


async function restoreBackup(row) {
  console.log("RESTORE BACKUP", row);
    try  {
      const response = await api.post(`/restore/${row.name}`);
      if (response.status === 200) {
        $q.notify({
          color: 'positive',
          position: 'top',
          message: `Backup restauré pour ${row.name}`,
        });
      } else {
        $q.notify({
          color: 'negative',
          position: 'top',
          message: `Erreur lors de la restauration de la sauvegarde pour ${row.name}`,
        });
      }
    } catch (error) {
      $q.notify({
        color: 'negative',
        position: 'top',
        message: `Erreur lors de la restauration de la sauvegarde pour ${row.name}`,
      });
  }
}

function selectBackup(row) {
  selectedBackup.value = row; // Affecter la ligne sélectionnée
  listLastBackup(); // Récupérer les fichiers de la dernière sauvegarde
  openNotification.value = true; // Ouvrir la boîte de notification
}

// Exemple de gestion d'une action pour une ligne
function onBackupClick(row) {
  $q.notify({
    color: 'info',
    position: 'top',
    message: `Backup démarré pour ${row.name}`,
  });
}

// Charger les données au montage
onMounted(() => {
  loadData();
});
</script>
<style scoped>
.border-green-4 {
  border: 2px solid #4caf50;
  border-radius: 4px;
  padding: 8px;
}
</style>
