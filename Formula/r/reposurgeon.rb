class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.7/reposurgeon-5.7.tar.gz"
  sha256 "e0875064f166348b37d190ba8c28f394949f0cfb4b397da97891d87c15e24ec4"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77235f469d34975d3ed78e766ff82070b414a4b92226fd0f9e3ae97df0cc8a88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bf03373d6bce73ac4990cc622f5de18e8b9661dd317ef608e38af3c16a63b4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "794b599ea46430ab2d428effba02106e7667db3024fb0cc211a5013fda3ed85d"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b553c1386ced332fa7a2cbcd29faac190eb73fd7c8d15f25d18a78bfc8c5de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d598a9a5d5f6a8d415bd21596970b1a16ca47c20a3d39ee79ebf0ad29700aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c0ba21bdf098cdd9fed4c6160129f0534da9282df7bf33631c7839aa8756b8"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build

  uses_from_macos "ruby"

  on_system :linux, macos: :catalina_or_older do
    depends_on "gawk" => :build
  end

  def install
    ENV.append_path "GEM_PATH", Formula["asciidoctor"].opt_libexec
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("#{bin}/reposurgeon read list")
  end
end