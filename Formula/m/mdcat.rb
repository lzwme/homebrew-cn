class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https:github.comswsnrmdcat"
  url "https:github.comswsnrmdcatarchiverefstagsmdcat-2.4.0.tar.gz"
  sha256 "1789347b35abff00e04f8941c6970a7ab8ae6ad0a0ec7a33fe3ef39021a7b17f"
  license "MPL-2.0"
  head "https:github.comswsnrmdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47072257cbcf508e022b601ee6524ab173b6df352232366fed7865937d40a8c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b39f389a754f88656051608e39566bf9bd47fafe07c4c8025d7bb402d51f2c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "213cdf57a3bffd9bdf71d4313956ab09f81da4838f7d23d05e3992cd9f016f93"
    sha256 cellar: :any_skip_relocation, sonoma:        "213fb271d01940fe3bc4f402f13e5378b41a79a0e606262c3a87eed84fbe2df2"
    sha256 cellar: :any_skip_relocation, ventura:       "1f224972cbe411a80064f62c611f1077fc3644477196bb94569647382fecae32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c41147f470d6ecc0f1d27807470621d60011f1e3e9b3939929178691c14e41"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https:github.comswsnrmdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin"mdcat", "--completions")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end