<template>
  <div class="q-pa-md">
    <div class="q-gutter-md row items-start">
      <q-card flat bordered  style="width: 250px">
        <q-card-section>
          <slot name="card-title" />
        </q-card-section>

        <q-separator />

        <q-card-section>
          <slot name="card-content" />
        </q-card-section>
      </q-card>
    </div>
  </div>
</template>
