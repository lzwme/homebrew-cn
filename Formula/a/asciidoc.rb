class Asciidoc < Formula
  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/8a/57/50180e0430fdb552539da9b5f96f1da6f09c4bfa951b39a6e1b4fbe37d75/asciidoc-10.2.0.tar.gz"
  sha256 "91ff1dd4c85af7b235d03e0860f0c4e79dd1ff580fb610668a39b5c77b4ccace"
  license "GPL-2.0-or-later"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c95543879c161bccf01990df57089827d585cc6a3e88a481e58f4980c6b1e763"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b59530ee279f26e422727e2f5c7ea0c8251629b4a12ea3ff3df2201788942ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06e286664c74ca53ffa2923c2d8fbdf2a853e65138580e59f8cff0423bcb2ca3"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9d131b85a4f4dd9b1c2eef29bff919346a320f616cb1d7c834f4d2216ffea86"
    sha256 cellar: :any_skip_relocation, ventura:        "274217e7cc92359fbaa63418b1bfcd8adc3c53239f1907e1fdec85ba69cdab9c"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d321c181a191b9e576be38a6e7b02780fe3d3d97877a7e6602067ad10de766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19a26ffa77e57c0504f2668f3e5673e4e94a50075d74716eabcda1dc9ed3d536"
  end

  depends_on "python-setuptools" => :build
  depends_on "docbook"
  depends_on "python@3.12"
  depends_on "source-highlight"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  def caveats
    <<~EOS
      If you intend to process AsciiDoc files through an XML stage
      (such as a2x for manpage generation) you need to add something
      like:

        export XML_CATALOG_FILES=#{etc}/xml/catalog

      to your shell rc file so that xmllint can find AsciiDoc's
      catalog files.

      See `man 1 xmllint' for more.
    EOS
  end

  test do
    (testpath/"test.txt").write("== Hello World!")
    system "#{bin}/asciidoc", "-b", "html5", "-o", testpath/"test.html", testpath/"test.txt"
    assert_match %r{<h2 id="_hello_world">Hello World!</h2>}, File.read(testpath/"test.html")
  end
end