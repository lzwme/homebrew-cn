class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.34.1.tar.gz"
  sha256 "21f257ff9d0717c630a39332add44c91ce1f1a5427f1c6e9013e3d238cf0f174"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "921b814cf52db44de986edd41a8050e637db4cbaf119d73741ca1bea9602e3d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d64da0512abd1fa5911f8733b334b8371ba88039b85dd384d8f6ea8fec52c62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd01628f1c04e32bb9864501912124cf5081b149ecebb8eb77f814c59bee1f11"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ff1d7dc9a5c3192a84cb35047888edcd840f0245d0926c3036dd9c13e44ba20"
    sha256 cellar: :any_skip_relocation, ventura:       "4ccfd60932602c2897c496671aaaecc45f8999107711389f428fae60db1d2fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c01ce1a8eb367ddabaee7c05472af4b15c07fc2d2b11e24ad80dbdfb399800e7"
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