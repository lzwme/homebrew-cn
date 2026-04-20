class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.5/reposurgeon-5.5.tar.gz"
  sha256 "2f112008e0c87e027dbfc3aa003c944d6034fa106021ec4b44bf72479a535f9c"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4c48bee7c25b638214f5c68fba2a1df4a19cc0a9676e7e28770954d3fbf2b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfae4ee27ce6e5f7ca105c597af9f997d43f5e816d8919013b8a3810fd4b1b68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bf36eda61f23850127f7fe3c7867e428299bf020dec1330ac829e49d1e44d8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc396c9038157ffecefbdd0ee873270e9fba23f610232aeac2e7e3b2f2054feb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe73f0db30706496caee3da9115e45322a70ebfc62617bb7d325a876d24c42f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a7e2b078c9d1d245c5f6e1f2736871c2ccf45596fd0c2ae9c44d8d239c0eef5"
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