class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.26.0.tar.gz"
  sha256 "20c4109bf30590e5633ae005329508c3fa772c3d86d0994bd2f770ade02dd6a7"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "558ec1ff5d4fe7ec96738165e6b0862b411fd64450c0b5f755a283dc534327c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acea4f32014df3a501a0ca6ea2b63ed8f5ad02408f5015c8d8768e9f413664c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57620a9f2a319ab4ef3494660c67f5bcfa986980cbbacca366e120fb46f9da3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7db6c5a6a3c755807bb3c11d10277d4b9971cc6db91576fb3bfbb4c0a6b9c99f"
    sha256 cellar: :any_skip_relocation, ventura:        "cec77700294ba2ccf172b8d91855776a4b5728b20b4ba9b67188d3957b9416a8"
    sha256 cellar: :any_skip_relocation, monterey:       "ff54b28d0dbaf9226d285eef77a0794b9e80e7733ebf501c57e7a5b96055ef22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8654d71db15993d6387dae5ea45d099ffe62c2023580939b92c7911b1ac7f495"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "manjust.1"
    bash_completion.install "completionsjust.bash" => "just"
    fish_completion.install "completionsjust.fish"
    zsh_completion.install "completionsjust.zsh" => "_just"
  end

  test do
    (testpath"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin"just"
    assert_predicate testpath"it-worked", :exist?
  end
end