class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.1/omniORB-4.3.1.tar.bz2"
  sha256 "0f42bc3eb737cae680dafa85b3ae3958e9f56a37912c5fb6b875933f8fb7390d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b8ff967349515c81d31b1d5a566616dbb7ed8fd8788940f35e99625e8340713c"
    sha256 cellar: :any,                 arm64_ventura:  "dc6b4f127e6f74924f29c3825373fc7d48f2a8eede75a53695e5e223d0e99a84"
    sha256 cellar: :any,                 arm64_monterey: "a3e3ed84f529fa6717b646e23e5adf6cb9b203bbab6ab3067d74d27a9b37cc51"
    sha256 cellar: :any,                 sonoma:         "485d98dde579d91bcf60fe200ee073d207aaca911a7ffd9560c2cae259b58f11"
    sha256 cellar: :any,                 ventura:        "7fc3798fd9ce75606395878769a7c5509aa7bf34e2089b7cf996b309268c2d0d"
    sha256 cellar: :any,                 monterey:       "e32e519b2a32838f57be93545434bfef818efaa4c9225443de81f2796ef41c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "040db4e19941ff7142bb719b991c08777b4165f78ceaa922e1465d964cfd5d74"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.12"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.1/omniORBpy-4.3.1.tar.bz2"
    sha256 "9da34af0a0230ea0de793be73ee66dc8a87e732fec80437ea91222e272d01be2"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.12")
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
      system "./configure", "--prefix=#{prefix}"
      ENV.deparallelize # omnipy.cc:392:44: error: use of undeclared identifier 'OMNIORBPY_DIST_DATE'
      system "make", "install"
    end
  end

  test do
    assert_equal version, resource("bindings").version, "`bindings` resource needs updating!"

    system "#{bin}/omniidl", "-h"
    system "#{bin}/omniidl", "-bcxx", "-u"
    system "#{bin}/omniidl", "-bpython", "-u"
  end
end