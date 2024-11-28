class Dum < Formula
  desc "Npm scripts runner written in Rust"
  homepage "https:github.comegoistdum"
  url "https:github.comegoistdumarchiverefstagsv0.1.19.tar.gz"
  sha256 "94af37a8f9a0689ea27d7f338b495793349b75f56b516c17cd207e7c47c52c4f"
  license "MIT"
  head "https:github.comegoistdum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b55256519cfd40c69330dea974562920fbe8202d5d20d87e8027044e7303bde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85cd3cb907cdd12a19237962c258ef81776fbc82f47a652125fe938fd2af76a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7451cfdf6ce688112b40e8fc8fdd688c33b1eb08f028f77cb41d004989896dd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b31347772c05158e37b9432f1d621bbd925369feccbe67abb5b026513e397aa0"
    sha256 cellar: :any_skip_relocation, ventura:       "407cf2dfc43a84146ebe0c18773888393d889a9eb2473a3b4c69d8fc68d509ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e8958901da48fb93e4955c0d2e9009682681398dee8d768c5a8e6b7e22dc98c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"package.json").write <<~JSON
      {
        "scripts": {
          "hello": "echo 'Hello, dum!'"
        }
      }
    JSON

    output = shell_output("#{bin}dum run hello")
    assert_match "Hello, dum!", output

    assert_match version.to_s, shell_output("#{bin}dum --version")
  end
end