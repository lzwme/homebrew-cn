class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://ghfast.top/https://github.com/simsong/bulk_extractor/releases/download/v2.1.1/bulk_extractor-2.1.1.tar.gz"
  sha256 "0cd57c743581a66ea94d49edac2e89210c80a2a7cc90dd254d56940b3d41b7f7"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9db981b920ec729cb3186889e48b6f1c13b8b273153d24b697db951e00d840e4"
    sha256 cellar: :any,                 arm64_sonoma:  "20963df12135abd102efcb43c1def1897bbc760c7d09e55d43dddc23c22e21d8"
    sha256 cellar: :any,                 arm64_ventura: "e63c90e821f4efa9ea419b75141c8138f5f23ad88828c2855fc858a432cf4f96"
    sha256 cellar: :any,                 sonoma:        "a75e06944d93dbe00aad38d16f3269891cef31adf0fcc0d8234d3685e27eb3c9"
    sha256 cellar: :any,                 ventura:       "f760c88edfaa3dbeac5fc07da90effc7f18609100d3f60351f7514d921104e45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69d7d459163ce21edb901dbaf3b28b4d49bbc6b8df0d55500bb88c8163bba7ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c71c5d880c8e2de6076b09cf2d9fe142dcc671f3f9242c038a4d3e709af0ed9"
  end

  head do
    url "https://github.com/simsong/bulk_extractor.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "re2"

  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh" if build.head?
    # Disable RAR to avoid problematic UnRAR license
    system "./configure", *std_configure_args, "--disable-rar", "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Install documentation
    (pkgshare/"doc").install Dir["doc/*.{html,txt,pdf}"]

    (lib/"python2.7/site-packages").install Dir["python/*.py"]
  end

  test do
    input_file = testpath/"data.txt"
    input_file.write "https://brew.sh\n(201)555-1212\n"

    output_dir = testpath/"output"
    system bin/"bulk_extractor", "-o", output_dir, input_file

    assert_match "https://brew.sh", (output_dir/"url.txt").read
    assert_match "(201)555-1212", (output_dir/"telephone.txt").read
  end
end