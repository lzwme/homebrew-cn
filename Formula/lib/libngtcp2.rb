class Libngtcp2 < Formula
  desc "IETF QUIC protocol implementation"
  homepage "https://nghttp2.org/ngtcp2/"
  url "https://ghfast.top/https://github.com/ngtcp2/ngtcp2/releases/download/v1.15.1/ngtcp2-1.15.1.tar.xz"
  mirror "http://fresh-center.net/linux/www/ngtcp2-1.15.1.tar.xz"
  sha256 "06f2eec7ca76552041050473d992d3063782e26fdff57533cb8cd8c9a6859a17"
  license "MIT"
  head "https://github.com/ngtcp2/ngtcp2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2065a28566351cb98a23ffa84edf76e6f2a0754e25c9141d797d61a97fc8b696"
    sha256 cellar: :any,                 arm64_sequoia: "f20ea5d5069d5e4048e99364117e99073ff2808c653db353fbed54bb37cb22b7"
    sha256 cellar: :any,                 arm64_sonoma:  "db90e03ed85435878ede1e4cbaaa265604c68c60a562f14366c9ce00f476e332"
    sha256 cellar: :any,                 arm64_ventura: "1a242a421cf69256429e7880147b9894a2210ff730063ee37df9bba4fa68edc5"
    sha256 cellar: :any,                 sonoma:        "95846c6f5f617e4fc981e613513aeefc89da066bc699df34ed72015cfff1cc3b"
    sha256 cellar: :any,                 ventura:       "8cb73d1424c9148c736572ec65fe828a8c646cfa455315303b772f1338f4deda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0239d0a5b9b55852b5909a6fd0156183503d02151dd2243e33d2b1a6b917780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fbb87d69ca10a4d8191d3f277f4530f864f7c1b1150e08a98229a451fc5fda6"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    # Warning: aggressive vibe-coding below.
    (testpath/"test-ngtcp2.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include <ngtcp2/ngtcp2.h>
      #include <ngtcp2/ngtcp2_crypto.h>

      static int recv_client_initial(ngtcp2_conn *conn, const ngtcp2_cid *dcid, void *user_data) {
          // Do nothing — just return 0 to indicate success
          return 0;
      }

      static int recv_crypto_data(ngtcp2_conn *conn,
                                  ngtcp2_encryption_level encryption_level,
                                  uint64_t offset,
                                  const uint8_t *data,
                                  size_t datalen,
                                  void *user_data) {
          // Accept all crypto data without processing
          return 0;
      }

      static int encrypt_cb(uint8_t *dest,
                            const ngtcp2_crypto_aead *aead,
                            const ngtcp2_crypto_aead_ctx *ctx,
                            const uint8_t *plaintext, size_t plaintextlen,
                            const uint8_t *nonce, size_t noncelen,
                            const uint8_t *ad, size_t adlen) {
          // Dummy encryption: just memcpy the plaintext to dest.
          // Not secure! Just for smoke testing.
          memcpy(dest, plaintext, plaintextlen);
          return 0; // success
      }

      static int decrypt_cb(uint8_t *dest,
                            const ngtcp2_crypto_aead *aead,
                            const ngtcp2_crypto_aead_ctx *ctx,
                            const uint8_t *ciphertext, size_t ciphertextlen,
                            const uint8_t *nonce, size_t noncelen,
                            const uint8_t *ad, size_t adlen) {
          // Dummy decryption: just memcpy ciphertext to dest
          memcpy(dest, ciphertext, ciphertextlen);
          return 0;
      }

      static int hp_mask_cb(uint8_t *dest,
                            const ngtcp2_crypto_cipher *hp,
                            const ngtcp2_crypto_cipher_ctx *hp_ctx,
                            const uint8_t *sample) {
          // For test: zero out header protection mask
          memset(dest, 0, 5);
          return 0;
      }

      static void rand_cb(uint8_t *dest, size_t destlen, const ngtcp2_rand_ctx *ctx) {
          // Dummy randomness: fill with incrementing values
          for (size_t i = 0; i < destlen; ++i) {
              dest[i] = (uint8_t)i;
          }
      }

      static int get_new_connection_id_cb(ngtcp2_conn *conn,
                                          ngtcp2_cid *cid,
                                          uint8_t *token,
                                          size_t cidlen,
                                          void *user_data) {
          // Dummy CID: fill with pattern
          for (size_t i = 0; i < cidlen; ++i) {
              cid->data[i] = (uint8_t)(0xA0 + i);
          }
          cid->datalen = cidlen;

          // Dummy stateless reset token
          memset(token, 0, NGTCP2_STATELESS_RESET_TOKENLEN);

          return 0;
      }

      static void delete_crypto_aead_ctx_cb(ngtcp2_conn *conn,
                                            ngtcp2_crypto_aead_ctx *aead_ctx,
                                            void *user_data) {
          // For smoke testing, nothing to free
          (void)conn;
          (void)aead_ctx;
          (void)user_data;
      }

      static int update_key_cb(ngtcp2_conn *conn,
                               uint8_t *rx_secret,
                               uint8_t *tx_secret,
                               ngtcp2_crypto_aead_ctx *rx_ctx,
                               uint8_t *rx_key,
                               ngtcp2_crypto_aead_ctx *tx_ctx,
                               uint8_t *tx_key,
                               const uint8_t *current_rx_secret,
                               const uint8_t *current_tx_secret,
                               size_t secretlen,
                               void *user_data) {
          // Dummy key update: just copy old secrets and keys
          memcpy(rx_secret, current_rx_secret, secretlen);
          memcpy(tx_secret, current_tx_secret, secretlen);

          memset(rx_key, 0, 32); // Dummy key
          memset(tx_key, 0, 32);

          memset(rx_ctx, 0, sizeof(*rx_ctx));
          memset(tx_ctx, 0, sizeof(*tx_ctx));

          return 0;
      }

      static void delete_crypto_cipher_ctx_cb(ngtcp2_conn *conn,
                                              ngtcp2_crypto_cipher_ctx *cipher_ctx,
                                              void *user_data) {
          // No-op for smoke testing
          (void)conn;
          (void)cipher_ctx;
          (void)user_data;
      }

      static int get_path_challenge_data_cb(ngtcp2_conn *conn,
                                            uint8_t *data,
                                            void *user_data) {
          // Dummy 8-byte challenge
          for (int i = 0; i < 8; ++i) {
              data[i] = (uint8_t)(0xC0 + i);
          }
          return 0;
      }

      int main(void) {
          ngtcp2_conn *conn = NULL;

          // Initialize callbacks (all NULL for now)
          ngtcp2_callbacks callbacks;
          memset(&callbacks, 0, sizeof(callbacks));
          callbacks.recv_client_initial = recv_client_initial;
          callbacks.recv_crypto_data = recv_crypto_data;
          callbacks.encrypt = encrypt_cb;
          callbacks.decrypt = decrypt_cb;
          callbacks.hp_mask = hp_mask_cb;
          callbacks.rand = rand_cb;
          callbacks.get_new_connection_id = get_new_connection_id_cb;
          callbacks.update_key = update_key_cb;
          callbacks.delete_crypto_aead_ctx = delete_crypto_aead_ctx_cb;
          callbacks.delete_crypto_cipher_ctx = delete_crypto_cipher_ctx_cb;
          callbacks.get_path_challenge_data = get_path_challenge_data_cb;

          // Connection IDs
          ngtcp2_cid dcid, scid;
          ngtcp2_cid_init(&dcid, (const uint8_t *)"\x01", 1);
          ngtcp2_cid_init(&scid, (const uint8_t *)"\x02", 1);

          // Settings
          ngtcp2_settings settings;
          ngtcp2_settings_default(&settings);

          // Transport parameters
          ngtcp2_transport_params params;
          memset(&params, 0, sizeof(params));
          params.initial_max_stream_data_bidi_local = 65535;
          params.initial_max_data = 65535;
          params.active_connection_id_limit = NGTCP2_DEFAULT_ACTIVE_CONNECTION_ID_LIMIT;

          // Required for server connections:
          params.original_dcid_present = 1;
          params.original_dcid = dcid;

          // Path (required now)
          ngtcp2_path path;
          memset(&path, 0, sizeof(path));

          // QUIC version (use draft-29 as default for test; or NGTCP2_PROTO_VER_V1 if available)
          uint32_t version = NGTCP2_PROTO_VER_V1;

          int rv = ngtcp2_conn_server_new(
              &conn,
              &dcid,
              &scid,
              &path,
              version,
              &callbacks,
              &settings,
              &params,
              NULL,  // token
              NULL   // user_data
          );

          if (rv != 0) {
              fprintf(stderr, "ngtcp2_conn_server_new failed: %s (%d)", ngtcp2_strerror(rv), rv);
              return 1;
          }

          printf("ngtcp2_conn_server_new succeeded.");

          ngtcp2_conn_del(conn);
          return 0;
      }
    C

    ENV.append_to_cflags "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-lngtcp2"

    system "make", "test-ngtcp2"
    system "./test-ngtcp2"
  end
end