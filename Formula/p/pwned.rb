require "languagenode"

class Pwned < Formula
  desc "CLI for the 'Have I been pwned?' service"
  homepage "https:github.comwKovacs64pwned"
  url "https:registry.npmjs.orgpwned-pwned-12.1.1.tgz"
  sha256 "9891674b8c269b5be7af510bbbe46c5edd04f803053719625797b38eef840863"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c171915ab827fa84b07952d9d5c1057089d36cbd019e90e4d75bcf89fb3f2236"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c171915ab827fa84b07952d9d5c1057089d36cbd019e90e4d75bcf89fb3f2236"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c171915ab827fa84b07952d9d5c1057089d36cbd019e90e4d75bcf89fb3f2236"
    sha256 cellar: :any_skip_relocation, sonoma:         "6db53fe5edcaf8d047abb481d06169808842ee24f377cba50b9350220dded27c"
    sha256 cellar: :any_skip_relocation, ventura:        "6db53fe5edcaf8d047abb481d06169808842ee24f377cba50b9350220dded27c"
    sha256 cellar: :any_skip_relocation, monterey:       "c171915ab827fa84b07952d9d5c1057089d36cbd019e90e4d75bcf89fb3f2236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4447db289b87357c479b1ed9ea79f2b33556bbd6af4ee389371c503607726c4c"
  end

  depends_on "node"

  conflicts_with "bash-snippets", because: "both install `pwned` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pwned --version")

    assert_match "Oh no — pwned", shell_output("#{bin}pwned pw homebrew 2>&1")
  end
end