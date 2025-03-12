class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.36.1.tar.gz"
  sha256 "3f0b06c29220eda817a652475f5e73356398550f2f9bf0c134fa0340a17e60cf"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c4b81b2baf1f6f2052456662baed0873f062c980603d86c662d4e728d90ce11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee9dd2352a81c7fb0fce1fe0f4353d303bfed6fb568d3bb72598debb7fc9813d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "397bd4bf768be395ca11dbf8da22d1c2cf4c73bac37200739f0ce54f6d9682f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7871367f70cca7298d542943cf5929b99eb2a6cfc91cbdc97e4c9602151fa14"
    sha256 cellar: :any_skip_relocation, ventura:       "beb0e79e430265228f323b13671c061a4dc34524abc12c11d607e56a94bbf2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36759d16bc48c2dcb7afd14f2c5c502856b780e7dba84ff66b9f3054aae793c6"
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