<template>
  <q-card>
    <!-- Section sticky avec les éléments de header -->
    <div
      class="sticky-header"
      v-if="slots.header"
    >
      <q-card-section class="q-pa-none">
        <q-toolbar :class="'bg-' + props.color + ' text-white'">
          <q-toolbar-title>
            <slot name="header" />
          </q-toolbar-title>
        </q-toolbar>

        <q-toolbar class="bg-white text-black">
          <!-- MultipleActions -->
          <template v-if="slots.stickyHeader">
            <slot name="stickyHeader" />
          </template>

          <q-space />

          <!-- Actions standards -->
          <slot name="actions" />
        </q-toolbar>

        <q-toolbar v-if="slots.filters">
          <slot name="filters" />
        </q-toolbar>
      </q-card-section>
    </div>

    <q-card-section :class="{ 'q-pa-none': $q.screen.lt.md }">
      <slot>
        <slot name="content" />
      </slot>
    </q-card-section>

    <q-card-section v-if="slots.footer">
      <slot name="footer" />
    </q-card-section>
  </q-card>
</template>

<script setup>
import { defineProps, useSlots } from "vue";
const props = defineProps({
  color: {
    type: String,
    default: "primary",
  },
});
const slots = useSlots();
</script>

<style>
.sticky-header {
  position: sticky;
  top: 0;
  z-index: 2;
  background-color: white;
}
</style>
