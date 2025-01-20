<template>
  <div class="q-pa-md">
    <div class="q-gutter-md row items-start">
    <!-- <DoubleCard>
      <template #card-title>
        test
      </template>
      <template #card-content>
        <div class="row">
          {{ data }}
        </div>
      </template>
    </DoubleCard> -->
    <q-card bordered>
      <q-card-section>
        <div class="text-h6">
      <q-icon name="backup" size="xl" color="primary" class="q-mr-sm" />
        Nombre de backup : {{ data?.backups?.length }}
      </div>
      </q-card-section>
    </q-card>
  </div>
  </div>
</template>

<script setup>
// Références
const $q = useQuasar();
const data = ref(null);

// Fonction pour faire un appel API
function loadData() {
  api.get('/api/backups')
    .then((response) => {
      data.value = response.data;
    })
    .catch(() => {
      $q.notify({
        color: 'negative',
        position: 'top',
        message: 'Loading failed',
        icon: 'report_problem',
      });
    });
}

onMounted(() => {
  loadData();
});
</script>
