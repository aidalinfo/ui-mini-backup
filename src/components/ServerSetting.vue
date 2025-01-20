<template>
  <!-- Hello {{ data?.server }} -->
   <div class="text-h6 q-pa-md">
    Configuration global du serveur
   </div>
   <CoreConfiguration :data="data" />
   <StockageConfiguration :data="data" class="q-mt-md"/>
</template>
<script setup>
import CoreConfiguration from './CoreConfiguration.vue';
import StockageConfiguration from './StockageConfiguration.vue';


const data = ref(null)
const loading = ref(true)
const $q = useQuasar();

async function loadData() {
  try {
    const response = await api.get('/api/server/config')
    data.value = response.data
    $q.notify({
      color: 'positive',
      position: 'top',
      message: 'Données chargées avec succès',
      icon: 'done'
    })
  } catch (error) {
    $q.notify({
      color: 'negative',
      position: 'top',
      message: 'Erreur durant la requete : ' + error.message,
      icon: 'report_problem'
    })
    console.error(error)
  } finally {
    loading.value = false
  }
}
onMounted(() => {
  loadData()
})
</script>
