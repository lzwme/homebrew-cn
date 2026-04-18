class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.4/reposurgeon-5.4.tar.gz"
  sha256 "52cc10255b10a160ee07f94d6981b924cf000642a4e2c9c47ff33520b3a7f9b6"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "750dbd7023f5da24ee5f3f786934140be4522130f88a42f5600ec24e97536f93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75d3cae9c5aa84f48d6cccc11c93e278f988fd6b86f84855357c4e9ff0f456f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36384f2f0f1a6a4c7dd1062f02e5ca51d36ac8b2d0f079f7ba7a1660245108ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a6ee584c579a030959d74731644f05615057d83c7b7dd4673b705ff401df7cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c96db17892d83d22dc58770852a76bb42fbeb94200bb19576dd2f088942cad76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7e64f475f9a97050a9f3bacc47f0a6243dcbf9ee7806963a56aa294725e6706"
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