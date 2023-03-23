class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.13.0",
      revision: "a4cf0dc4437de35fce4860857b64569d092a9b5a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0ab46d056d76a5fdbc093400ac4b711f5e0c3bc53487181d6ea737c94f18016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43ea4b9235deb691b2b993802072ebf63dca789b6a2bee539147227c8b810517"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c0db75816520d3bc8d72f2192e5f13c46e0ae6cb946e9ec28408b5cdb447ea2"
    sha256 cellar: :any_skip_relocation, ventura:        "caaa90952a983daa65c2509791fbc2d599d0c30eb3dddb06dda66b125f92dcd3"
    sha256 cellar: :any_skip_relocation, monterey:       "b9f7655499eb8b6e2dacbfde911b7f6e8a3ab667a1f8c8d4fc9b2948a277a3d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb0028c775d22728e6112e89c2bb63618ac14acead4e28015c6387aca7b7481f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687e9eaab2c25653904fc1590d1a8ede63472de49eed2d7305e32ec0b51833db"
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