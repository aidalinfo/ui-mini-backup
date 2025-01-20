<template>
  <card-layout>
    <template #header>
      Configuration stockage S3
    </template>
    <template #content>
      <div class="row q-pa-md q-gutter-md">
        <q-list
          bordered
          class="rounded-borders q-pa-md"
          style="width: 500px"
          v-for="(storage, storageName) in data?.server?.RStorage || {}"
          :key="storageName"
        >
          <q-item-label header>Configuration du stockage S3</q-item-label>
          <!-- Parcours des différents stockages -->
          <div class="q-mb-md">
            <div class="flex items-center">
              <!-- Icône du logo -->
              <q-icon name="img:src/assets/cleaning.svg" size="md"/>
              <!-- Nom du stockage avec marge -->
              <q-item-label class="text-h4 text-secondary">
                {{ storageName }}
              </q-item-label>
            </div>
            <!-- Parcours des propriétés du stockage -->
            <q-item v-for="(value, key) in storage" :key="key">
              <q-item-section>
                <q-item-label class="text-weight-medium text-body1">{{ key }}</q-item-label>
                <q-item-label caption>{{ value }}</q-item-label>
              </q-item-section>
            </q-item>

            <q-separator spaced inset />
          </div>
        </q-list>
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
