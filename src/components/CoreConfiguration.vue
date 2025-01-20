<template>

  <card-layout>
    <template #header>
      Configuration core
    </template>
    <template #content>
      <div class="q-gutter-md row items-start q-pa-md">
      <!-- GO ENV MODE CARD -->
      <q-card bordered class="text-primary rounded-borders shadow-1 q-mr-md">
        <q-card-section>
          <div class="text-h6">Port :  {{ data?.server?.Server?.Env }} </div>
          <div>
          </div>
        </q-card-section>
      </q-card>
        <!-- PORT CARD -->
      <q-card bordered class="text-primary rounded-borders shadow-1 q-mr-md">
        <q-card-section>
          <div class="text-h6">Port :  {{ data?.server?.Server?.Port }} </div>
          <div>
          </div>
        </q-card-section>
      </q-card>
      <!-- DEBUG MODE CARD -->
      <q-card bordered class="text-primary rounded-borders shadow-1 q-mr-md">
        <q-card-section>
          <div class="text-h6">Debug mode :  {{ data?.server?.Server?.Debug }} </div>
          <div>
          </div>
        </q-card-section>
      </q-card>
      <!-- CHEMIN DE LOG Card -->
      <q-card bordered class="text-primary rounded-borders shadow-1 q-mr-md">
        <q-card-section>
          <div class="text-h6">Chemin du fichier de log :  {{ data?.server?.Server?.Log }} </div>
          <div>
          </div>
        </q-card-section>
      </q-card>
    </div>
    </template>
  </card-layout>
</template>

<script setup>
import CardLayout from 'src/layouts/CardLayout.vue';
const props = defineProps({
  data: {
    type: Object,
    default: null,
  },
});
</script>
