<template>
  <div class="q-pa-md q-gutter-sm">
    <!-- <q-btn label="Alert" color="primary" @click="alert = true" />
    <q-btn label="Confirm" color="primary" @click="confirm = true" />
    <q-btn label="Prompt" color="primary" @click="prompt = true" /> -->


    <q-dialog v-model="props.enable" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-avatar :icon="icon" color="primary" text-color="white" />
          <span class="q-pa-sm">
            <slot name="message">
            </slot>
          </span>
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="Cancel" @click="actionCancel" color="primary" v-close-popup  size="md"/>
          <q-btn flat label="Restaurer 🚀" class="bg-primary text-white"  @click="props.actionConfirm(props.selectedBackup)" color="primary" v-close-popup  />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>

<script setup>
const props = defineProps({
  enable: {
    type: Boolean,
    default: true,
  },
  selectedBackup: {
    type: Object,
    default: null,
  },
  icon : {
    type: String,
    default: 'settings_backup_restore',
  },
  actionConfirm: {
    type: Function,
    default: () => {},
  },
  actionCancel: {
    type: Function,
    default: () => {},
  },
});
</script>
