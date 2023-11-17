class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghproxy.com/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.11.23.tar.gz"
  sha256 "8c4e20a332e2966671cc14bdd4e628aa7363192c036b53963e75ef8f27846ce7"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce95a36657c5a8c89141af51e92853e45539acf1ad9e20c974475953f2d1edeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04bb78948cff6e478fce8c46789e97e2c84d8044afcca70e3dcf51e3524382de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2931504991bfdc06be3934b30d0164d837817a3ec809c68e614f66ac646abece"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3d61343a62fbc629745c9f0f2890cb4eef4b4a21de77f005161116f1f2fb06d"
    sha256 cellar: :any_skip_relocation, ventura:        "e25cee129189bcc5d3aceecb31e5bdc9ce6ac0f95719902f813f05aaabac2b80"
    sha256 cellar: :any_skip_relocation, monterey:       "5205a39c181f25aaf4db185def61ae11bb5eadff8353b73ded78bb2f3053f3f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a39f27b5c935bfa7de06d6a15275dae1afa6e24f3a661b5fc83296ac01cffcdb"
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