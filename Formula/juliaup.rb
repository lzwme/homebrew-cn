class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghproxy.com/https://github.com/JuliaLang/juliaup/archive/v1.11.15.tar.gz"
  sha256 "026f8712a20ab972607668f7f030fc86a15ee307f2fa7521f0edfaac0dcde1f2"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67def61ec4cd8a13b39c0d0cf27bbbf8471dd91df5ab270dd2114770fd246228"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81018ead3f5360a1d6bac8f3b409166a585b296ab6e4c604a8b234bac6dfa576"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae37eec46f61b09ebd5411a4ab2251a8f9efc049b605b2cba20f592ea68e155c"
    sha256 cellar: :any_skip_relocation, ventura:        "ddf91c4825a0c452045e210a290098dc2e9b4638f19842f070a9b1791e82d7d6"
    sha256 cellar: :any_skip_relocation, monterey:       "21aaef9acb505debb557d3dda203007e83a3ec97335afc724f6463a7de8c4193"
    sha256 cellar: :any_skip_relocation, big_sur:        "02af2883c063cc7b4e3e9472f7a80d6502028b3a530e0806c31698e0da8fcf60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c57b4739876bd4a2b5dd0b7dc9ba6823b52466aa3d32c53955c25e11f5f4886d"
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