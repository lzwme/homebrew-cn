class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghfast.top/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.18.5.tar.gz"
  sha256 "c1e741fcc70471eaf70bc136fdc28d981494f6da001518e6c95f009fe77848ba"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e2863a3eda1294949c06e785da7196e6f3ae9b78315285cbc4e0fd9f739cd3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "033673fe9025f482989fe6c07360bfc89aea53a63dabe44c6efe84de9f6f886e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac0f7da76e69d41980478d5c4be8e9a18e44f36353d053062456229f018f53b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b6b02c83b55fee946e4927b6596d59cd0b60b2aa5f7250a6a17f678f6971c7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44d19b24d6189d2221771586fceff189acdd62f2e80cb1884ec5a3cc7426b7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "873ada34e3a8f4320892a02bc8fb476fe3631dd97cc76846984ccece364e74bb"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end