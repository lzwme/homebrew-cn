class Sqlsmith < Formula
  desc "Random SQL query generator"
  homepage "https:github.comanse1sqlsmith"
  url "https:github.comanse1sqlsmithreleasesdownloadv1.4sqlsmith-1.4.tar.gz"
  sha256 "b0821acbe82782f6037315549f475368be3592cefe2c3c540f9cf52aa70d2f55"
  license "GPL-3.0-only"
  revision 2

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f23ecdd9d829aed9d235d951286d224bf13054c79dfccaf008a1ab5b983ec81"
    sha256 cellar: :any,                 arm64_ventura:  "5af43469979b34385992159d26a7276b9cf415b491a43e19b01777b9626de358"
    sha256 cellar: :any,                 arm64_monterey: "cec1e169f6c580b3b321d2d4f9185552c8a1cdc66de34934e0f32e0282f3457e"
    sha256 cellar: :any,                 sonoma:         "ecec370eeaeb84ab79a7bbf1d0abff13f2847ccd36a791b769cd7a15aa222c6a"
    sha256 cellar: :any,                 ventura:        "69c40cc6d183bf37ffd6f22b6044a11859388b48a763d9bb344bbbd440d70acd"
    sha256 cellar: :any,                 monterey:       "12d7c834c4a826ebd595ba3b7a77bcf512c29eb968855841f04a047d0f1dba60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c5a9f4c1d06d00eb0880c27c4fd7adf559888f193149ec272a67befd9a1393c"
  end

  head do
    url "https:github.comanse1sqlsmith.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpqxx"

  uses_from_macos "sqlite"

  def install
    ENV.append_to_cflags "-DNDEBUG"
    system "autoreconf", "-fvi" if build.head?
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    cmd = %W[
      #{bin}sqlsmith
      --sqlite
      --max-queries=100
      --verbose
      --seed=1
      2>&1
    ].join(" ")
    output = shell_output(cmd)

    assert_match "Loading tables...done.", output
    assert_match "Loading columns and constraints...done.", output
    assert_match "Generating indexes...done.", output
    assert_match "queries: 100", output
    assert_match "impedance report:", output
  end
end