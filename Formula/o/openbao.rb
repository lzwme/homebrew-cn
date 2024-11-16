class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https:openbao.org"
  url "https:github.comopenbaoopenbao.git",
      tag:      "v2.0.3",
      revision: "a2522eb71d1854f83c7e2e02fdbfc01ae74c3a78"
  license "MPL-2.0"
  head "https:github.comopenbaoopenbao.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8302b47beb4fcdf7666f8eed87518721c4253e71122e73d7175c50b5d773e754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdcab819c2550899884daf12564f0dbe334796ebf1469779a8e70ce7af55c871"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c75a30b1b54dbfabd8864b324225a342aae7c16cfdf38f5b4cb427d157cca59e"
    sha256 cellar: :any_skip_relocation, sonoma:        "16eba9ceb081e26566a9fd7720de29cfd863f386dcc9f19aea9a4769df9047c6"
    sha256 cellar: :any_skip_relocation, ventura:       "f6cbb98a7790b9ebe32f6ee7a131560b955708a012f33661fb20413cdaad1451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "977ac13ebe95e7ac86b5597516785a73b2e1b47e0f03edea94e1276433d73924"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https:github.comopenbaoopenbaoissues731
  depends_on "yarn" => :build

  uses_from_macos "curl" => :test

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    ENV.prepend_path "PATH", Formula["node@22"].opt_libexec"bin" # for npm
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