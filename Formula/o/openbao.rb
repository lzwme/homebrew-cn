class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https:openbao.org"
  url "https:github.comopenbaoopenbao.git",
      tag:      "v2.0.0-beta20240618",
      revision: "1c194a17153afe958e1fc74f17e59f16b8d6d95e"
  license "MPL-2.0"
  head "https:github.comopenbaoopenbao.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05569884f8d47f8e4163768f5193c3140e7425d64a3a42900369b8bdf334f223"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e93f0aed96a95f00dfd195627d9a14b8e59a9eec50bf0d3f7e34769cc430721e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73aec864eb75c6330ae59ce2fc6e8482a947b6f7a912b37957e74ea2d00fac21"
    sha256 cellar: :any_skip_relocation, sonoma:         "34ecfcdd597db274b27f7b73346b9d67f99ac712ced3b9c84083373cb639da39"
    sha256 cellar: :any_skip_relocation, ventura:        "3ddf7ed5f5d7727231a669b9649a904f8e2a14b4cd46a2e0180d658341bab30d"
    sha256 cellar: :any_skip_relocation, monterey:       "9b72e7ab6cee1e74ec06094b5dd063f28f7fc7754534518d0286d013eaa15aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a45b87593643db336ee386d84bf1969eabfe6214fc80f56d96edc325a60d8d7e"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "curl" => :test

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