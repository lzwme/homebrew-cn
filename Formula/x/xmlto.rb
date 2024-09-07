class Xmlto < Formula
  desc "Convert XML to another format (based on XSL or other tools)"
  homepage "https://pagure.io/xmlto/"
  url "https://releases.pagure.org/xmlto/xmlto-0.0.28.tar.bz2"
  sha256 "1130df3a7957eb9f6f0d29e4aa1c75732a7dfb6d639be013859b5c7ec5421276"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/xmlto/?C=M&O=D"
    regex(/href=.*?xmlto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1cb49d979ff5540b66560c7edf4a5f6b882530764736de05cec5238917c92dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44603a27e95fdeb74994325d50a23fcc9e6994ec1ff44f9120d1633a72e01321"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "556ea7b76e3ddfb0928570c41dee6bd30ab5792c4967543131a8278d03c6bda4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e99c2ba4f2fd3758e861502cebd4681add5a6f3787e036c2cd179d4fd7aaa9d8"
    sha256 cellar: :any_skip_relocation, ventura:        "ac11deec2e89a8853c52f9257fcaf5b8951b2f8fe9328cb9f354b0f47bd458f8"
    sha256 cellar: :any_skip_relocation, monterey:       "b3965cff11de7ac70104caa7239c30fa1150ecc5749d9106899d64b0f2f15bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db69918f37e9992e0f7b584a92244a6d75575b36d7642779d4be188aac57e355"
  end

  depends_on "docbook"
  depends_on "docbook-xsl"

  uses_from_macos "libxslt"

  on_macos do
    # Doesn't strictly depend on GNU getopt, but macOS system getopt(1)
    # does not support longopts in the optstring, so use GNU getopt.
    depends_on "gnu-getopt"
  end

  def install
    # GNU getopt is keg-only, so point configure to it
    ENV["GETOPT"] = Formula["gnu-getopt"].opt_bin/"getopt" if OS.mac?
    # Prevent reference to Homebrew shim
    ENV["SED"] = "/usr/bin/sed"
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    # Allow pre-C99 syntax
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1500

    ENV.deparallelize
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      <?xmlif if foo='bar'?>
      Passing test.
      <?xmlif fi?>
    EOS
    assert_equal "Passing test.", pipe_output("#{bin}/xmlif foo=bar", (testpath/"test").read).strip
  end
end