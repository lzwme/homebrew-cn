class Miniserve < Formula
  desc "High performance static file server"
  homepage "https:github.comsvenstarominiserve"
  url "https:github.comsvenstarominiservearchiverefstagsv0.27.1.tar.gz"
  sha256 "b65580574ca624072b1a94d59ebf201ab664eacacb46a5043ef7b81ebb538f80"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "be43e375c504a35fcf180b59a851724831be29d7060d9f3b843109181d64f9fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d273865ba9a53f5b907704c9a16c4931adfc700a1ef791ca304855a8d6a7ec7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b40b9a228e90b806c89f7d20e5d956a69e471c353d934b32538a32388e8449b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca5058a0f23e1e5a433d7a4ed71a08b5f681c50186551b02529494591721a303"
    sha256 cellar: :any_skip_relocation, sonoma:         "691faeff3ba624cf4c38476dca96923c4429fe9ec9f7be2c9d332d6b5fea9ff9"
    sha256 cellar: :any_skip_relocation, ventura:        "35de9b3c07f440ebe3d4eac291850d2e7757893e87c06190fc440a462d67f502"
    sha256 cellar: :any_skip_relocation, monterey:       "455879bb35de16f96355612fab7882901f274673d4a49cdf54ba884be04c7deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaec7cdcce89e4e2d53e5fedba84d60a8dcdf11dd3dd0846eed2681beb198bed"
  end

  depends_on "rust" => :build

  # rust 1.80 build patch, upstream commit ref, https:github.comsvenstarominiservecommit2fbfcbfe17b5c12630ccb03b6ccd31cb4b8316cc
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchese022b2c42fbda33637b8a5c62847e8d6dd51942bminiserverust-1.80.patch"
    sha256 "b7a4557f18e72eb106da5a47e74e4ff718330cd60cf4b6458ad09eba7f9ba9f1"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"miniserve", "--print-completions")
    (man1"miniserve.1").write Utils.safe_popen_read(bin"miniserve", "--print-manpage")
  end

  test do
    port = free_port
    pid = fork do
      exec bin"miniserve", bin"miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end