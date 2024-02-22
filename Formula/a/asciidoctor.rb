class Asciidoctor < Formula
  desc "Text processor and publishing toolchain for AsciiDoc"
  homepage "https:asciidoctor.org"
  url "https:github.comasciidoctorasciidoctorarchiverefstagsv2.0.21.tar.gz"
  sha256 "78a54eaf88fe9f5e6945578313aac4096a9d8c49e760932b3ef66c599483f10b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e30f71491a030ea2dec1c63f0b00e061a03ecabdc9eb5e94852637b6c6b0b638"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e30f71491a030ea2dec1c63f0b00e061a03ecabdc9eb5e94852637b6c6b0b638"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e30f71491a030ea2dec1c63f0b00e061a03ecabdc9eb5e94852637b6c6b0b638"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1330a677e96b6a3a21b4412eea992f56385944ce4e7929ac1e62c5d10ba1693"
    sha256 cellar: :any_skip_relocation, ventura:        "f1330a677e96b6a3a21b4412eea992f56385944ce4e7929ac1e62c5d10ba1693"
    sha256 cellar: :any_skip_relocation, monterey:       "f1330a677e96b6a3a21b4412eea992f56385944ce4e7929ac1e62c5d10ba1693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebc56f94f9fd1338d7f9e5372cde31a9c8ba76af4c26551825bdf57e32a5c366"
  end

  # Some gems require >= ruby 2.7
  depends_on "ruby"

  # Dependencies are for the asciidoctor-pdf, coderay, pygments.rb and rouge gems

  resource "polyglot" do
    url "https:rubygems.orggemspolyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

  resource "treetop" do
    url "https:rubygems.orggemstreetop-1.6.12.gem"
    sha256 "ed48add684a2d7a8fd6e3b8b027d8ee5983b50977ae691913131a24f1746ac29"
  end

  resource "ttfunk" do
    url "https:rubygems.orggemsttfunk-1.7.0.gem"
    sha256 "2370ba484b1891c70bdcafd3448cfd82a32dd794802d81d720a64c15d3ef2a96"
  end

  resource "pdf-core" do
    url "https:rubygems.orggemspdf-core-0.9.0.gem"
    sha256 "4f368b2f12b57ec979872d4bf4bd1a67e8648e0c81ab89801431d2fc89f4e0bb"
  end

  resource "prawn" do
    url "https:rubygems.orggemsprawn-2.4.0.gem"
    sha256 "82062744f7126c2d77501da253a154271790254dfa8c309b8e52e79bc5de2abd"
  end

  resource "ruby-rc4" do
    url "https:rubygems.orggemsruby-rc4-0.1.5.gem"
    sha256 "00cc40a39d20b53f5459e7ea006a92cf584e9bc275e2a6f7aa1515510e896c03"
  end

  resource "hashery" do
    url "https:rubygems.orggemshashery-2.1.2.gem"
    sha256 "d239cc2310401903f6b79d458c2bbef5bf74c46f3f974ae9c1061fb74a404862"
  end

  resource "Ascii85" do
    url "https:rubygems.orggemsAscii85-1.1.0.gem"
    sha256 "9ce694467bd69ab2349768afd27c52ad721cdc6f642aeaa895717bfd7ada44b7"
  end

  resource "afm" do
    url "https:rubygems.orggemsafm-0.2.2.gem"
    sha256 "c83e698e759ab0063331ff84ca39c4673b03318f4ddcbe8e90177dd01e4c721a"
  end

  resource "pdf-reader" do
    url "https:rubygems.orggemspdf-reader-2.12.0.gem"
    sha256 "61e72a4839cf2b3735a4b08dcb00e23c57a51d199494a5b11bd78e49d7b91758"
  end

  resource "prawn-templates" do
    url "https:rubygems.orggemsprawn-templates-0.1.2.gem"
    sha256 "117aa03db570147cb86fcd7de4fd896994f702eada1d699848a9529a87cd31f1"
  end

  resource "prawn-table" do
    url "https:rubygems.orggemsprawn-table-0.2.2.gem"
    sha256 "336d46e39e003f77bf973337a958af6a68300b941c85cb22288872dc2b36addb"
  end

  resource "rexml" do
    url "https:rubygems.orggemsrexml-3.2.6.gem"
    sha256 "e0669a2d4e9f109951cb1fde723d8acd285425d81594a2ea929304af50282816"
  end

  resource "matrix" do
    url "https:rubygems.orgdownloadsmatrix-0.4.2.gem"
    sha256 "71083ccbd67a14a43bfa78d3e4dc0f4b503b9cc18e5b4b1d686dc0f9ef7c4cc0"
  end

  resource "public_suffix" do
    url "https:rubygems.orggemspublic_suffix-5.0.4.gem"
    sha256 "35cd648e0d21d06b8dce9331d19619538d1d898ba6d56a6f2258409d2526d1ae"
  end

  resource "addressable" do
    url "https:rubygems.orggemsaddressable-2.8.6.gem"
    sha256 "798f6af3556641a7619bad1dce04cdb6eb44b0216a991b0396ea7339276f2b47"
  end

  resource "css_parser" do
    url "https:rubygems.orggemscss_parser-1.16.0.gem"
    sha256 "f70fb492254418522ea77c01d57bf64452d6c7465001926c3620d0b50289b1a2"
  end

  resource "prawn-svg" do
    url "https:rubygems.orggemsprawn-svg-0.33.0.gem"
    sha256 "6228b5115719e34b9c0f585b0434328e8191bd11a2393e60da1ee26470771f29"
  end

  resource "prawn-icon" do
    url "https:rubygems.orggemsprawn-icon-3.0.0.gem"
    sha256 "dac8d481dee0f60a769c0cab0fd1baec7351b4806bf9ba959cd6c65f6694b6f5"
  end

  resource "concurrent-ruby" do
    url "https:rubygems.orggemsconcurrent-ruby-1.2.3.gem"
    sha256 "82fdd3f8a0816e28d513e637bb2b90a45d7b982bdf4f3a0511722d2e495801e2"
  end

  # asciidoctor supports the Python 3 pygments syntax highlighter via pygments.rb ~> 2.0.0
  # Unless pygments.rb is installed in the asciidoctor libexec gems folder, asciidoctor will
  # not be able to find the gem. Installing the pygment.rb gem as part of the main asciidoctor
  # formula ensures it's available if users choose to install and enable the Pygments syntax
  # highlighter.
  resource "pygments.rb" do
    url "https:rubygems.orggemspygments.rb-2.4.1.gem"
    sha256 "61a3c9a00c01d53fa5fe7f6f6d2c461abc5b50cf6db9438c04b812d80f8d94be"
  end

  resource "asciidoctor-pdf" do
    url "https:rubygems.orggemsasciidoctor-pdf-2.3.13.gem"
    sha256 "fa03c42e317060b0492005b77665c376d36d75e50859a51fc21b7f85d1030e77"
  end

  resource "coderay" do
    url "https:rubygems.orggemscoderay-1.1.3.gem"
    sha256 "dc530018a4684512f8f38143cd2a096c9f02a1fc2459edcfe534787a7fc77d4b"
  end

  resource "rouge" do
    url "https:rubygems.orggemsrouge-4.2.0.gem"
    sha256 "60dd666b3a223467dc72f5b7384764dfd7ad4e50b0df9eff072be58123506eba"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "asciidoctor.gemspec"
    system "gem", "install", "asciidoctor-#{version}.gem"
    bin.install Dir[libexec"binasciidoctor"]
    bin.install Dir[libexec"binasciidoctor-pdf"]
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install_symlink "#{libexec}gemsasciidoctor-#{version}manasciidoctor.1" => "asciidoctor.1"
  end

  test do
    %w[rouge coderay].each do |highlighter|
      (testpath"test.adoc").atomic_write <<~EOS
        = AsciiDoc is Writing Zen
        Random J. Author <rjauthor@example.com>
        :icons: font
        :source-highlighter: #{highlighter}

        Hello, World!

        == Syntax Highlighting

        Python source.

        [source, python]
        ----
        import something
        ----

        List

        - one
        - two
        - three
      EOS
      output = Utils.popen_read bin"asciidoctor", "-b", "html5", "-o", "test.html", "test.adoc", err: :out
      refute_match(optional gem '#{highlighter}' is not available, output)
      assert_match "<h1>AsciiDoc is Writing Zen<h1>", File.read("test.html")
      assert_match(<pre class="#{highlighter} highlight">i, File.read("test.html"))
      system bin"asciidoctor", "-r", "asciidoctor-pdf", "-b", "pdf", "-o", "test.pdf", "test.adoc"
      assert_match "Title (AsciiDoc is Writing Zen)", File.read("test.pdf", mode: "rb")
    end
  end
end