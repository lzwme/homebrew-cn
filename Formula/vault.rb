# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  # TODO: Migrate to `python@3.11` in v1.13
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.12.3",
      revision: "209b3dd99fe8ca320340d08c70cff5f620261f9b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f30563a5dcb9fe92b7439a9a4fecb1789eb08db3ea4f82a6cb6d9fee83cb09ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "549d24ffcf66e9afd9a2ba3cf8b5b0320e0d1f5b04dbd4630c67e3e4f2068e42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5289af1b6a76f7c6d11373e5d980b99f001e24beebd5baa6bca0086e08abbea7"
    sha256 cellar: :any_skip_relocation, ventura:        "5ffae0053e7bb700529ff25f2e3b049f0aadc492ce24dbc19dd4d7f6856a37b1"
    sha256 cellar: :any_skip_relocation, monterey:       "e708a438c3f5c93c63aef960f03ddaa2521fa2ce6be7bb6aba681e1ba5f22259"
    sha256 cellar: :any_skip_relocation, big_sur:        "77f01925187cd19a9e43d5f04f9c22ae94d532f3398acbc7b089d8e7bdd13aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c4b07f1bb40be91e003fdd64d950716c86d519ed08d4f872ca22c6d20161a6"
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  depends_on "node@18" => :build
  depends_on "python@3.10" => :build # TODO: Migrate to `python@3.11` in v1.13
  depends_on "yarn" => :build

  def install
    # Needs both `npm` and `python` in PATH
    ENV.prepend_path "PATH", Formula["node@18"].opt_libexec/"bin"
    ENV.prepend_path "PATH", "#{ENV["GOPATH"]}/bin"
    ENV["PYTHON"] = "python3.10"
    system "make", "bootstrap", "static-dist", "dev-ui"
    bin.install "bin/vault"
  end

  service do
    run [opt_bin/"vault", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/vault.log"
    error_log_path var/"log/vault.log"
  end

  test do
    port = free_port
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = "127.0.0.1:#{port}"
    ENV["VAULT_ADDR"] = "http://127.0.0.1:#{port}"

    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 5
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end