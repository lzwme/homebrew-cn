class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.comjj-vcsjj"
  url "https:github.comjj-vcsjjarchiverefstagsv0.30.0.tar.gz"
  sha256 "86f8df1e4e76c6a4bcdb728fa74876bacf931641157d16f6e93ebeb5bac0151c"
  license "Apache-2.0"
  head "https:github.comjj-vcsjj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "833b9681b5f65fd35fa365fd0638d047bbb25e776163499b7f43f65ed238e44c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67ea879212c9ec6115a610c438a40854baf7d2f3a7a433d0816dd97b9437e739"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b60adff4aa38dda9c9f05880d9fa13c8e906193eaa283c032be1e3e4081e2489"
    sha256 cellar: :any_skip_relocation, sonoma:        "20557d44e25fcd36dd5a66399aa0e36b54b77b7fde91548cedeba36dd2263887"
    sha256 cellar: :any_skip_relocation, ventura:       "b6fed70088fe219ed523d9e877310c7951b554a87e2f528ca8b218eb993ba3ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8b0eaa58ce0ebb2a5f9b59db8e931f36a210f0e4cd8dc48e8c7cc1382941d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35ef27032c768550d2613536adf6d449054844d98402fb1a628fccf530b0580c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"jj", shell_parameter_format: :clap)
    system bin"jj", "util", "install-man-pages", man
  end

  test do
    require "utilslinkage"

    touch testpath"README.md"
    system bin"jj", "git", "init"
    system bin"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}jj file list")
    assert_match "initial commit", shell_output("#{bin}jj log")
  end
end