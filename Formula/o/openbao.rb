class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https:openbao.org"
  url "https:github.comopenbaoopenbao.git",
      tag:      "v2.0.2",
      revision: "96853bb4de27ab8ffd1b0c2898c691460d43edeb"
  license "MPL-2.0"
  head "https:github.comopenbaoopenbao.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dcd3f86dcea6e0cc2be156adddfd60736cc95ba74b44372ff5cd370473a849a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b755adfde26f3c9e7efaf241da78b00b5c7b3cae815f3ea2c591079b745a0a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f05acc1a92bc289eb1f6296ef7d378e3c260ce882815ba4bc8826cea793573d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e47a002aa13ea1f489db2ce634779f303aa3d7bfe737de3184610350238c55bb"
    sha256 cellar: :any_skip_relocation, ventura:       "4306de08507771cc02ad3bab677ac148b844ddea9c74c757bd8c058d51c980ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695b69e0d426b78233958bd8cb836a457da6787d91e1f0ff6bf821d4ab2fb0e2"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "curl" => :test

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    ENV.prepend_path "PATH", Formula["node"].opt_libexec"bin" # for npm
    system "make", "bootstrap", "static-dist", "dev-ui"
    bin.install "binbao"
  end

  service do
    run [opt_bin"bao", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var"logopenbao.log"
    error_log_path var"logopenbao.log"
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http:#{addr}"

    pid = fork { exec bin"bao", "server", "-dev" }
    sleep 5
    system bin"bao", "status"
    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}robots.txt")
    Process.kill("TERM", pid)
  end
end