class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.2/omniORB-4.3.2.tar.bz2"
  sha256 "1c745330d01904afd7a1ed0a5896b9a6e53ac1a4b864a48503b93c7eecbf1fa8"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6b9bad8d4f7372e0f9568276b49511e6f0f8a78ae427763f7daf8aec80731fc5"
    sha256 cellar: :any,                 arm64_ventura:  "2a8ac392eebb30eae2e1089136751947bc68e58b74e417c0ee484e1f129758c4"
    sha256 cellar: :any,                 arm64_monterey: "75801990b9584a9d5a7e43d526bd001cdb56d3f5f6aa004e5adc4f08195c1649"
    sha256 cellar: :any,                 sonoma:         "a39294772af7cf6ae59acab001ebc1e03655e77d3ba759f8771c403eed49192b"
    sha256 cellar: :any,                 ventura:        "e717811dd542866080999cfb647b3eca9181f26434ffb3fe7c1ff56bdc751f10"
    sha256 cellar: :any,                 monterey:       "17d4cf5755cc3df5b9f260e784fef0880f729a1e818a38f0c123e4e052b6df0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5da9acdba77e7fc002d59d33bf9bd5eee9517e0df6e0169f374aa5723bdf0056"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "python@3.12"
  uses_from_macos "zlib"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.2/omniORBpy-4.3.2.tar.bz2"
    sha256 "cb5717d412a101baf430f598cac7d69231884dae4372d8e2adf3ddeebc5f7ebb"
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    ENV["PYTHON"] = python3 = which("python3.12")
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    args = ["--with-openssl"]
    args << "--enable-cfnetwork" if OS.mac?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
      system "./configure", *std_configure_args
      ENV.deparallelize # omnipy.cc:392:44: error: use of undeclared identifier 'OMNIORBPY_DIST_DATE'
      system "make", "install"
    end
  end

  test do
    system bin/"omniidl", "-h"
    system bin/"omniidl", "-bcxx", "-u"
    system bin/"omniidl", "-bpython", "-u"
  end
end