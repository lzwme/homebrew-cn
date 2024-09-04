class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https:openbao.org"
  url "https:github.comopenbaoopenbao.git",
      tag:      "v2.0.1",
      revision: "88383dece6b4ff1b3b242280a54aeabef8101495"
  license "MPL-2.0"
  head "https:github.comopenbaoopenbao.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be992d09774b947b4f8e927f13a663295c60d4727c573a6457744c0c84efbb37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dc122744d96e9de3c3e368314b59cb8509503b9106aad2939a5814189a5b954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04871dae0992fd44664c0914bae0195135e38bbc4a14dfd11024d40a795aa6a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e887223fce9ce947889846a2177daf281c2231695b78c0ff879d2e7e3ebe5e2"
    sha256 cellar: :any_skip_relocation, ventura:        "ad277032b71ba035f915b4088569df993f53c1d007901384be3b9fdf126b097b"
    sha256 cellar: :any_skip_relocation, monterey:       "3abece6fd6f3848b250d034d360949cef53db97579dbba7975e7792752d750b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "022eeda2b1ad2c059aa3cddb1570d2f8031a3b00c039d22d6ef36432dbf2062f"
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