class Xapian < Formula
  desc "C++ search engine library"
  homepage "https:xapian.org"
  url "https:oligarchy.co.ukxapian1.4.24xapian-core-1.4.24.tar.xz"
  sha256 "eda5ae6dcf6b0553a8676af64b1fd304e998cd20f779031ccaaf7ab9a373531a"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https:xapian.orgdownload"
    regex(href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bcba507d3df7d2f760f14ac6e9e7c3267d018aea8ff253a43e8079aeb53dc1b9"
    sha256 cellar: :any,                 arm64_ventura:  "c65d6bec3f6b4cf34d1e443c8378f91b0075a55c05afaf5b9ea4d4d1927f477b"
    sha256 cellar: :any,                 arm64_monterey: "9ae46890756661b50abb01882b18accf52343006d3530d18e4d504dc350d4f9d"
    sha256 cellar: :any,                 sonoma:         "573b6ac05eac13c1b686bb1f1ee58ca07d720277181ca7b155e4f5157572c21b"
    sha256 cellar: :any,                 ventura:        "7260ce2a63dc21c39a3a8764c011ab3c155025bd2015c111a9a08de5b3406f92"
    sha256 cellar: :any,                 monterey:       "8d20ed8c0da9ae9d6035bf2f4577eb99432103d6ca5a5d89d30701ddd0c61d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02fb04af41c95cb3820c2b284da4dabc1c68b68d4c540232c32fe64eb2a00182"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https:oligarchy.co.ukxapian1.4.23xapian-bindings-1.4.23.tar.xz"
    sha256 "e0bc8cc0ecf0568549c50b51fd59e4cffb5318d6f202afcd4465855ef5f33f7d"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def python3
    "python3.12"
  end

  def install
    ENV["PYTHON"] = which(python3)
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    resource("bindings").stage do
      ENV["XAPIAN_CONFIG"] = bin"xapian-config"
      ENV.delete "PYTHONDONTWRITEBYTECODE" # makefile relies on install .pyc files

      site_packages = Language::Python.site_packages(python3)
      ENV.prepend_create_path "PYTHON3_LIB", prefixsite_packages

      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexecsite_packages
      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec"vendor"site_packages

      system ".configure", *std_configure_args, "--disable-silent-rules", "--with-python3"
      system "make", "install"
    end
  end

  test do
    system bin"xapian-config", "--libs"
    system python3, "-c", "import xapian"
  end
end