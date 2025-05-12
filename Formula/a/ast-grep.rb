class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.38.1.tar.gz"
  sha256 "e1378aef969fbedd450f52eb85bf56a0389acdfd09316c130b28ade920a59cb3"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53fa646ebfe63b5c030a6f03c72b358eee97e68106056c95832855dc04e9bd4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f96a95439fdd92ebfb50ac22084d29a2b391ffaeb1ab5fd31e5c14c9c2c559d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dcffa2e091ba3251b5950262acec52c4cd3d1b6871b5de87ceb7526a4c4cd06"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e8c73bbf61767004d0ad8a0d7774b73d832a3305254fc90c0645a784e2a0983"
    sha256 cellar: :any_skip_relocation, ventura:       "ffcb33c2383d76067c4e1f47bf03a9d74be962453d3d068acc1b512fcf7cb3ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28ae8692020ba9755cf3700809ab63e3dbff7145456615de32e180ee5c7d3def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "828848a6417695418375227a00f2d4f0a643e4764a8793895c2644caa56c8f57"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"ast-grep", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end