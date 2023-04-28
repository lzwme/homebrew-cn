class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/4.36/reposurgeon-4.36.tar.gz"
  sha256 "0fe147909c673fc2377026dcbd81ccf205dc9d9daf0694a304e1621d94e9ad92"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30d788e559b984c23ca6ceb0d9504324e465820b7c38a75cb81eac6e8ba94e5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1130d6c68713eb1061a5bb8ab4bdbdd5767a6fc8ee54a1b9aeac199454af420"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d3dbfd59c527524d17caba99c3263e53080172976e1466fe5ed043e8f349820"
    sha256 cellar: :any_skip_relocation, ventura:        "fe0473459981226c9d9436111f73f1e84abaebf6e8475cb9443bab60d2f0f9c3"
    sha256 cellar: :any_skip_relocation, monterey:       "a10aa7dd508efb16e191b27dc7fbd3366f704e0c9bbaca6ef2ab2a1f2c26e3ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b0774b48600dcbcf02d26e34d19ea7cb722be64fa92e19e2cc6e7f1940ea8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3875c8b456fb0b36f21ad76832526a910061915c9976b953406003781d4afe6f"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  uses_from_macos "ruby"

  on_system :linux, macos: :catalina_or_older do
    depends_on "gawk" => :build
  end

  def install
    ENV.append_path "GEM_PATH", Formula["asciidoctor"].opt_libexec
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
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