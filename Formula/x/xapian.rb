class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.29/xapian-core-1.4.29.tar.xz"
  sha256 "c55c9bc8613ad3ec2c218eafca088c218ab7cddcba7ef08f3af0e542f4e521bc"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "529da91065d00808e836e7ab0700d5344d58bed36dfb88109831b16370cf9582"
    sha256 cellar: :any,                 arm64_sequoia: "014927707879ba359a2045d1f19ac3cfc96e3948a91729d51b6ec4bb38d221f7"
    sha256 cellar: :any,                 arm64_sonoma:  "3fc2adca698ac9a8896ae7993284350fb05903306d434b82dfda72ce94df30a5"
    sha256 cellar: :any,                 sonoma:        "f703e5658e96de70094b07bad06e40ec11a2361b56e3c2f6dd46855f647ccc9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70c6bae9ae2fee7cdf558e6f9d88c9f2180510f072b60065871ef76a12e3ebc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef2cd6c921c2a77443d79757e912be5f1d519e9dfa3b39e23bc7666203236eb"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.29/xapian-bindings-1.4.29.tar.xz"
    sha256 "1740e927bb6850ef67d99a0b808a1b7c9af3f16c15577e0261bbd3fc016fc8ce"

    livecheck do
      formula :parent
    end
  end

  def python3
    "python3.14"
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    ENV["PYTHON"] = which(python3)
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    resource("bindings").stage do
      ENV["XAPIAN_CONFIG"] = bin/"xapian-config"
      ENV.delete "PYTHONDONTWRITEBYTECODE" # makefile relies on install .pyc files

      site_packages = Language::Python.site_packages(python3)
      ENV.prepend_create_path "PYTHON3_LIB", prefix/site_packages

      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/site_packages
      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"vendor"/site_packages

      system "./configure", *std_configure_args, "--disable-silent-rules", "--with-python3"
      system "make", "install"
    end
  end

  test do
    system bin/"xapian-config", "--libs"
    system python3, "-c", "import xapian"
  end
end