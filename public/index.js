/** @typedef {{load: (Promise<unknown>); flags: (unknown)}} ElmPagesInit */

/** @type ElmPagesInit */
export default {
  load: async function (elmLoaded) {
    const app = await elmLoaded;
    console.log("App loaded", app);
  },
  flags: function () {
    return {
      initialRandomSeed: (() => {
        const array = new Uint32Array(1);
        window.crypto.getRandomValues(array);
        return array[0];
      })(),
      availableLocales: (() => {
        if (navigator.languages && navigator.languages.length) {
          return navigator.languages;
        } else {
          return [navigator.userLanguage || navigator.language || navigator.browserLanguage || 'en'];
        }
      })(),
    };
  },
};
