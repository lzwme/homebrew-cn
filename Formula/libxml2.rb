class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.11/libxml2-2.11.2.tar.xz"
  sha256 "ac11e8b66176d49514bd4fa17c3fbdb3414aef64518ff9db536862e4682e2a64"
  license "MIT"

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b0513dbd3a5efcdd624b05f1d91e28f0502918862b399811e19702b7cc9c44f9"
    sha256 cellar: :any,                 arm64_monterey: "fab14f6e62f47943ccaef6cb00b135d8b19eaa82a3030ad6f229fc55f518ca3c"
    sha256 cellar: :any,                 arm64_big_sur:  "50e74549971b93ff184f8efff92057f186204b2985e196761a8b1e97fba2baa4"
    sha256 cellar: :any,                 ventura:        "06f852937ee42b19d36660f6c87935f5d9c8bb4072556de155b92b69fd6522b6"
    sha256 cellar: :any,                 monterey:       "7031d67798cbb667606a9c7dcc97af709ed8ecb98ebbe98f51de9307894f39c7"
    sha256 cellar: :any,                 big_sur:        "eed40482b53ecc4a9ed6517aeed05bd5a4a816a56cd0522474407e6bc6433282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09e0e00d89fe41390fd4b8ad50d50f2fb07932d1393050959b3f96858238e69b"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "pkg-config" => :test
  depends_on "icu4c"
  depends_on "readline"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-history",
                          "--with-icu",
                          "--without-python",
                          "--without-lzma"
    system "make", "install"

    cd "python" do
      sdk_include = if OS.mac?
        sdk = MacOS.sdk_path_if_needed
        sdk/"usr/include" if sdk
      else
        HOMEBREW_PREFIX/"include"
      end

      includes = [include, sdk_include].compact.map do |inc|
        "'#{inc}',"
      end.join(" ")

      # We need to insert our include dir first
      inreplace "setup.py", "includes_dir = [",
                            "includes_dir = [#{includes}"

      pythons.each do |python|
        system python, *Language::Python.setup_install_args(prefix, python)
      end
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libxml/tree.h>

      int main()
      {
        xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");
        xmlNodePtr root_node = xmlNewNode(NULL, BAD_CAST "root");
        xmlDocSetRootElement(doc, root_node);
        xmlFreeDoc(doc);
        return 0;
      }
    EOS

    # Test build with xml2-config
    args = shell_output("#{bin}/xml2-config --cflags --libs").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Test build with pkg-config
    ENV.append "PKG_CONFIG_PATH", lib/"pkgconfig"
    args = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    pythons.each do |python|
      with_env(PYTHONPATH: prefix/Language::Python.site_packages(python)) do
        system python, "-c", "import libxml2"
      end
    end
  end
end