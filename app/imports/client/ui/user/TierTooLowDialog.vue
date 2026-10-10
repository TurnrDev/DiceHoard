<template lang="html">
  <dialog-base>
    <v-layout
      column
      align-center
      justify-center
    >
      <h2 style="margin: 48px 28px 16px">
        This feature is not available
      </h2>
      <h3>
        This action is currently unavailable for your account.
      </h3>
    </v-layout>
    <v-spacer slot="actions" />
    <v-btn
      slot="actions"
      text
      @click="$store.dispatch('popDialogStack')"
    >
      Cancel
    </v-btn>
  </dialog-base>
</template>

<script lang="js">
import DialogBase from '/imports/client/ui/dialogStack/DialogBase.vue';

export default {
  components: {
    DialogBase,
  },
}
</script>
