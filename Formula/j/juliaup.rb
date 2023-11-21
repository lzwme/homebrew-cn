class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghproxy.com/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "57cfc5d7fc57acba6e90f5708f2420a2601f9a9a7bf3f1ca2f4c8e26d6e30df9"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "011990a417001e41eda5aaedb6cf0443fdecfe3025c4d8eb7abd2ad096ee2aa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3722b6757a53051ce167151b89e10d887ef4bf9273eb59759ea7b24a77c972a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736bb5ecf33d067d5ba5e89adf54eb3e5f02b058e1c31e9c34e79b4846d33703"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8042409a0380e9b13eb61cd42c2ebbceeadb909ce9101f7d35d0b3ffc392656"
    sha256 cellar: :any_skip_relocation, ventura:        "d101234ea750bac92c3a4f7f727dd8573819c961a23310e9afb7ff2494f150ab"
    sha256 cellar: :any_skip_relocation, monterey:       "f67710d645a5037ac9dc3b4df20f4d62fec7eaa9c7d5570a0fd0bd757c041dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "292a814ba70eb7c6829f8a10bc6658f42dbc64482cbabb6ee9bda79cf3d76206"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end