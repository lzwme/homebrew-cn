class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghproxy.com/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "c68d05d594569203fa8846e16f9e4e8ea485837c527dce637bde60aee54cca7e"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5619109bee283173594822be0d1ff465b98f0355dd2b870494900a93782684e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d903e3dc1e0711aaec421bae55cfcc691db15f0ea8bd01de941f82c05e2e2da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c03d79ce76f788554400c728f6f4643207dfe9d5f5f1df101612aabdef805416"
    sha256 cellar: :any_skip_relocation, sonoma:         "83f2081a7cf29cf4d21c1e3af2cbba7d518119ae7c0f62dec8441eb9e91c5409"
    sha256 cellar: :any_skip_relocation, ventura:        "2453634f23872f81a674ad1f9bfed86ec1233a1a1a7d0a28e4c5b40ac245420a"
    sha256 cellar: :any_skip_relocation, monterey:       "e47cf5475fe10cd18a7b7d333183e28e66e90680dc7361bf7f5c7b84d2bd9d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39fdfd32bc100fb11923f0510e35b431ea2a85069b48cb1e36340d483e2a1475"
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