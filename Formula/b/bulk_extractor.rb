class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://ghfast.top/https://github.com/simsong/bulk_extractor/releases/download/v2.1.1/bulk_extractor-2.1.1.tar.gz"
  sha256 "0cd57c743581a66ea94d49edac2e89210c80a2a7cc90dd254d56940b3d41b7f7"
  license "MIT"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0eeb51340d665d0d000912c6d16d60a7511c1e910be99a786fd456e418c260e0"
    sha256 cellar: :any,                 arm64_sonoma:  "c02a8c20ef6e7c5214b0d4aaa3883ea70433e496220acaf774163649fe357c44"
    sha256 cellar: :any,                 arm64_ventura: "234712b8f102e6fddb941c3dbaee77d9cea2c18bd5cd3b7bd9ec43d1a97a2a0e"
    sha256 cellar: :any,                 sonoma:        "604b9074da535d325d007aa47aff87164b218a1d8158b219bea05aa986b315f5"
    sha256 cellar: :any,                 ventura:       "c5e8205cd079854b272967537829922fff5388e72429169c59ab6260eb680af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c5fc1a205bf3625e78a5dfc32895a38cd5c655b9012648592ebda3aaaa32c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fbf259ce6abf7f96c71c18aeffea8a67343affdc1de696790b6e3dba9a12d28"
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