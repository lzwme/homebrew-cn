class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.31/xapian-core-1.4.31.tar.xz"
  sha256 "fecf609ea2efdc8a64be369715aac733336a11f7480a6545244964ae6bc80811"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1187ef07a3e2a9897e45f4ed680bf4edf8c7f9da085e55f632f37ff9402bd78f"
    sha256 cellar: :any,                 arm64_sequoia: "1e9c22448a4406ac3062ec624f3666a341e0783386027e498960d6ca52f9a191"
    sha256 cellar: :any,                 arm64_sonoma:  "52c810946969ca8d125423e3093f890ae03ae365009962464c1b90170b5d8cbe"
    sha256 cellar: :any,                 sonoma:        "d715cdb15a596daa2109ed0e1a22a927d0ed6d96bb3ffac46c99708c1e237994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c9e666fae75687880b9ff40c49a96a5e0a6595f9e487e840798977045330909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "841f77ec2f355da5b42256315fa255b7da6e458466dc0642bdfa997761387add"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "sphinx-doc" => :build

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.31/xapian-bindings-1.4.31.tar.xz"
    sha256 "a38cc7ba4188cc0bd27dc7369f03906772047087a1c54f1b93355d5e9103c304"

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