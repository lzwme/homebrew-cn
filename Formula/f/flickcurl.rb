class Flickcurl < Formula
  desc "Library for the Flickr API"
  homepage "https://librdf.org/flickcurl/"
  url "https://download.dajobe.org/flickcurl/flickcurl-1.26.tar.gz"
  sha256 "ff42a36c7c1c7d368246f6bc9b7d792ed298348e5f0f5d432e49f6803562f5a3"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?flickcurl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a6338b6a11dd25f5a0ac9d3c6d0385e49b519b09f6f882a644ff7a76ac285cd0"
    sha256 cellar: :any,                 arm64_sequoia:  "3c35eff6c5e815cb9292d51b61a1ef74ee432630b234934863e11b3f2dcea4f4"
    sha256 cellar: :any,                 arm64_sonoma:   "6cb56f37cf48d22e339fb06c76714ac263e83e1bbd4f745cbba9ddad44b06f68"
    sha256 cellar: :any,                 arm64_ventura:  "3a7f75cacbb1175cfa2ee72dcda7f99f01ba138b7d488e008a9ece38fc8deaf1"
    sha256 cellar: :any,                 arm64_monterey: "024bb774db8841eb554099408b89d25d810d37cb2876fbf73f7b5664ad55229a"
    sha256 cellar: :any,                 arm64_big_sur:  "49065801b7dfe7880206948a41c58ae5f190b50e3acbbe7d14ff24d29a30db0c"
    sha256 cellar: :any,                 sonoma:         "e32c3a962a4e0294d75cce91c1572ded882751acb909a844070a1d7a2456d5be"
    sha256 cellar: :any,                 ventura:        "416ebb0aa48eaefa4391bcfe0dc4e030ef657a9d9194de06c7a61b5d3ad3dd61"
    sha256 cellar: :any,                 monterey:       "5b02e704797f3519e3ace4764467339d554557b91a3085e8fc4418c19e22220f"
    sha256 cellar: :any,                 big_sur:        "90c210da66773047b62e3f5922382d97a7da8d4b17b178b25149a07d910c6f4a"
    sha256 cellar: :any,                 catalina:       "6188ec0f80d29fb32f2f6bb08ee8eb3fd7aa66cd1e3a4f8c4a138f33a5b5271a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8d4ac8aae2a14e2cb1237f58a016f586c885171704ee45c5c2fd1e017b935398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3590c3c9a44504b1a7493018de9e009fc1ff929beb7cc890f8907eed5fc0e05"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/flickcurl -h 2>&1", 1)
    assert_match "flickcurl: Configuration file", output
  end
end