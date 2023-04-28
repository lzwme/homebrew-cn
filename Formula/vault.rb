# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.13.2",
      revision: "b9b773f1628260423e6cc9745531fd903cae853f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "082ea563e2592e05f043eaa2d44127fec471990d6674fa2c69f1f840e48e1807"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bc3e8d55c923f7f4dfece6e756a833da5c58520954b3b5e107f30e2141f2c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddd6f1a3b8d6b0a4f486668c9fd5cabb414ce78b787ab6f772b4b9e0b41cc076"
    sha256 cellar: :any_skip_relocation, ventura:        "30713759b1b2e1e8cd1ae69f1fb45aaee3faae7b32aa8de771b1f62d51ac9624"
    sha256 cellar: :any_skip_relocation, monterey:       "0c1c633039a2d53e1c177d17e7adb0d425912233117519125236b14919890e30"
    sha256 cellar: :any_skip_relocation, big_sur:        "47c0f3594012d4db86fc476b579aa47bc7bf8fd972cef0368919189dc3bd5d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "638fd56258bb9cdc55c2080037c6db40dd8b4f48cc5faf7f42bf61d2e116a35d"
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  depends_on "node@18" => :build
  depends_on "python@3.11" => :build
  depends_on "yarn" => :build

  def install
    # Needs both `npm` and `python` in PATH
    ENV.prepend_path "PATH", Formula["node@18"].opt_libexec/"bin"
    ENV.prepend_path "PATH", "#{ENV["GOPATH"]}/bin"
    ENV["PYTHON"] = "python3.11"
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