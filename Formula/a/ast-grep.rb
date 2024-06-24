class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.24.0.tar.gz"
  sha256 "9fc4c50eadb4ff5148dd21aceb4a27b65d2869832d26945bb649c491a98a923f"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97ea2ddc5fa32f2cb298c33fceaea968a2fd5ae738833ecafc65cf5bef407e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58a99b7c000aa167ca780ea9f0394c44938b4f078e5301af2337ea3e19d3bf65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4711535425eac77455a5411a299aa1e52b38afd899adc7384377f078e525aa05"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb52f44b2df32ec2c50d39157a4377c49c98b860ebbb05e844df6db25ac398cf"
    sha256 cellar: :any_skip_relocation, ventura:        "718be5ff6d3afa4580af5be1eb88e8497d317dd67aa0d7b62976606ff2ee9afd"
    sha256 cellar: :any_skip_relocation, monterey:       "46b1679a12f6d1c17823a59c70115c58eceba4a16f0bdbf256073c4c93a46d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e74646ccbfdfc1d552dae952d844dd9387501b4ef61d90ad235b2752eea269b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end