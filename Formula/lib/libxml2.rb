class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http:xmlsoft.org"
  url "https:download.gnome.orgsourceslibxml22.13libxml2-2.13.3.tar.xz"
  sha256 "0805d7c180cf09caad71666c7a458a74f041561a532902454da5047d83948138"
  license "MIT"

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(libxml2[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cc72be468bb8621b286b7d5702f8d6b1c62435c4deb7a4836c9fc1b589ed2232"
    sha256 cellar: :any,                 arm64_sonoma:   "60fae010908a477182adf4bd01f33796a1a05bb6eb33059c4e2f6d817b60d655"
    sha256 cellar: :any,                 arm64_ventura:  "58f36e33c3c80c748b96759bdea5245fc969b65b448d1a02733ba13174e0faa7"
    sha256 cellar: :any,                 arm64_monterey: "b3091b47ebea0a2a646f58525f92156b962cd5c76fd1cae4f0a86e5e5ab2a4a0"
    sha256 cellar: :any,                 sonoma:         "16a96d824e62c68557954f1ef1e7e0c45ed7d1767496dec9c341b6bef9b5e637"
    sha256 cellar: :any,                 ventura:        "3e902495665dfbf3a98a4578cecf7ee2738f53f15713f4c053939cc7cd97e9f3"
    sha256 cellar: :any,                 monterey:       "942e9cbf5f554359c3ec38b5cc93c68b54b0f7e5f2a4916279cce6a6422467c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68b231988738df70bd936a4862dbb76a4470aa3ebc2cd6963398beb90925905c"
  end

  head do
    url "https:gitlab.gnome.orgGNOMElibxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "pkg-config" => :test
  depends_on "icu4c"
  depends_on "readline"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(^python@\d\.\d+$) }
        .map { |f| f.opt_libexec"binpython" }
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system ".configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--disable-silent-rules",
                          "--with-history",
                          "--with-http",
                          "--with-icu",
                          "--without-python",
                          "--without-lzma"
    system "make", "install"

    cd "python" do
      sdk_include = if OS.mac?
        sdk = MacOS.sdk_path_if_needed
        sdk"usrinclude" if sdk
      else
        HOMEBREW_PREFIX"include"
      end

      includes = [include, sdk_include].compact.map do |inc|
        "'#{inc}',"
      end.join(" ")

      # We need to insert our include dir first
      inreplace "setup.py", "includes_dir = [",
                            "includes_dir = [#{includes}"

      # Needed for Python 3.12+.
      # https:github.comHomebrewhomebrew-corepull154551#issuecomment-1820102786
      with_env(PYTHONPATH: buildpath"python") do
        pythons.each do |python|
          system python, "-m", "pip", "install", *std_pip_args, "."
        end
      end
    end
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <libxmltree.h>

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
    args = shell_output("#{bin}xml2-config --cflags --libs").split
    system ENV.cc, "test.c", "-o", "test", *args
    system ".test"

    # Test build with pkg-config
    ENV.append "PKG_CONFIG_PATH", lib"pkgconfig"
    args = shell_output("#{Formula["pkg-config"].opt_bin}pkg-config --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system ".test"

    pythons.each do |python|
      with_env(PYTHONPATH: prefixLanguage::Python.site_packages(python)) do
        system python, "-c", "import libxml2"
      end
    end
  end
end