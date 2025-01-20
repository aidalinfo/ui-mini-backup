<template>
  <q-page padding>
    Générateur de configuration de sauvegarde
    <q-form @submit.prevent="generateYaml">
      <!-- Nom du backup -->
      <q-input
        v-model="nameBackup"
        label="Nom du backup"
        placeholder="Nom unique pour cette configuration"
        outlined
        class="q-my-md"
        :rules="[(val) => !!val || 'Nom requis']"
      />
      <!-- Sélecteur pour le type de sauvegarde -->
      <q-select
        v-model="selectedType"
        :options="types"
        label="Type de sauvegarde"
        outlined
        class="q-my-md"
        :rules="[(val) => !!val || 'Type requis']"
      />

      <!-- Affichage dynamique des champs -->
      <div v-if="fields.length">
        <div v-for="field in fields" :key="field.name" class="q-mb-md">
          <!-- Champs texte ou mot de passe -->
          <q-input
            v-if="field.type === 'text' || field.type === 'password'"
            v-model="form[field.name]"
            :type="field.type"
            :label="field.label"
            :placeholder="field.placeholder"
            outlined
            dense
            :rules="[field.required ? (val) => !!val || 'Champ requis' : null]"
          />
          <!-- Checkbox pour les booléens -->
          <q-checkbox
            v-else-if="field.type === 'boolean'"
            v-model="form[field.name]"
            :label="field.label"
          />
          <!-- Liste (textarea simulé) -->
          <q-input
            v-else-if="field.type === 'list'"
            v-model="form[field.name]"
            type="textarea"
            :label="field.label"
            :placeholder="field.placeholder"
            outlined
            dense
          />
        </div>
      </div>

      <!-- Chemins -->
      <div class="row">
        <div class="col-5">
          <q-input
            v-model="path.local"
            label="Chemin local"
            placeholder="Chemin local"
            outlined
            dense
            :rules="[(val) => !!val || 'Champ requis']"
          />
        </div>
        <div class="col-5">
          <q-input
            v-model="path.s3"
            label="Chemin S3"
            placeholder="Chemin S3"
            outlined
            dense
            :rules="[(val) => !!val || 'Champ requis']"
          />
        </div>
      </div>

      <!-- Retention -->
      <div class="row">
        <div class="col-5">
          <q-input
            v-model="retention.standard"
            label="Retention standard (jours)"
            placeholder="Nombre de jours"
            outlined
            dense
            :rules="[(val) => !!val || 'Champ requis']"
          />
        </div>
        <div class="col-5">
          <q-input
            v-model="retention.glacier"
            label="Retention glacier (jours)"
            placeholder="Nombre de jours"
            outlined
            dense
            :rules="[(val) => !!val || 'Champ requis']"
          />
        </div>
      </div>

      <!-- Schedule -->
      <div class="row">
        <div class="col-5">
          <q-input
            v-model="schedule.standard"
            label="Schedule standard"
            placeholder="CRON standard"
            outlined
            dense
            :rules="[(val) => !!val || 'Champ requis']"
          />
        </div>
        <div class="col-5">
          <q-input
            v-model="schedule.glacier"
            label="Schedule glacier"
            placeholder="CRON glacier"
            outlined
            dense
            :rules="[(val) => !!val || 'Champ requis']"
          />
        </div>
      </div>

      <!-- Bouton pour générer le YAML -->
      <q-btn type="submit" label="Générer YAML" color="primary" />

      <!-- Affichage du YAML généré -->
      <q-card flat bordered class="q-my-md" v-if="yamlOutput">
        <q-card-section>
          <h6>YAML généré :</h6>
          <pre>{{ yamlOutput }}</pre>
        </q-card-section>
      </q-card>
    </q-form>
  </q-page>
</template>

<script setup>
import yaml from "js-yaml"; // `npm install js-yaml`
import backupTypes from "src/utils/creator_config.json";

const nameBackup = ref(null);
const selectedType = ref(null);
const form = ref({});
const path = ref({ local: "", s3: "" });
const retention = ref({ standard: "", glacier: "" });
const schedule = ref({ standard: "", glacier: "" });
const yamlOutput = ref("");
const fields = ref([]);

const types = Object.keys(backupTypes.backupTypes).map((key) => ({
  label: key.toUpperCase(),
  value: key,
}));

watch(selectedType, async (value) => {
  if (value) {
    fields.value = backupTypes.backupTypes[value.value]?.fields || [];
  }
});

function generateYaml() {
  if (!nameBackup.value || !selectedType.value) {
    alert("Veuillez remplir tous les champs requis.");
    return;
  }

  const data = {
    backups: {
      [nameBackup.value]: {
        type: selectedType.value.value,
        [selectedType.value.value]: { ...form.value },
        path: { ...path.value },
        retention: {
          standard: { days: retention.value.standard },
          glacier: { days: retention.value.glacier },
        },
        schedule: {
          standard: schedule.value.standard,
          glacier: schedule.value.glacier,
        },
      },
    },
  };

  yamlOutput.value = yaml.dump(data, {
    noRefs: true,
    lineWidth: 80,
  });
}
</script>
