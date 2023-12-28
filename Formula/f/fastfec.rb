class Fastfec < Formula
  desc "Extremely fast FEC filing parser written in C"
  homepage "https:github.comwashingtonpostFastFEC"
  # Check whether PCRE linking issue is fixed in Zig at version bump.
  url "https:github.comwashingtonpostFastFECarchiverefstags0.1.9.tar.gz"
  sha256 "1f6611b76c54005580d937cbac75b57783a33aa18eb32e4906ae919f6a1f0c0e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8cd93c3ee8341f51200494f88ea7988b80f9572f31ff3ce887613aca2eeb7666"
    sha256 cellar: :any,                 arm64_monterey: "e4a418b3cc7102643171d183f760d8472e346bfd867b0f9b1c9efcf77ef989e3"
    sha256 cellar: :any,                 arm64_big_sur:  "cf8a31a76e96182523864464e836c933da99eb1166dca8c9ea3565c279f4e5f5"
    sha256 cellar: :any,                 ventura:        "f8b6f48029a6b92236f23a25fac991956522d2ea3b406367dad94a718c581179"
    sha256 cellar: :any,                 monterey:       "03535ac3132d60e752fa89765d510550586906ab23831997b64298957f3b6326"
    sha256 cellar: :any,                 big_sur:        "2eae2434276d7188f96c8897118f4573a9beab27feabb38215b7d317c8067ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7566d57296f3b7928138acda003a04e9b64dcffa8d2c0d843a1610cffcf31853"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build

  on_macos do
    # Zig attempts to link with `libpcre.a` on Linux.
    # This fails because it was not compiled with `-fPIC`.
    # Use Homebrew PCRE on Linux when upstream resolves
    #   https:github.comziglangzigissues14111
    # Don't forget to update the `install` method.
    depends_on "pcre" # PCRE2 issue: https:github.comwashingtonpostFastFECissues57
  end

  resource "homebrew-13360" do
    url "https:docquery.fec.govdcdevposted13360.fec"
    sha256 "b7e86309f26af66e21b28aec7bd0f7844d798b621eefa0f7601805681334e04c"
  end

  # Fix install_name rewriting for bottling.
  # https:github.comwashingtonpostFastFECpull56
  patch do
    url "https:github.comwashingtonpostFastFECcommit36cf7e84083ac2c6dbd1694107e2c0a3fdc800ae.patch?full_index=1"
    sha256 "d00cc61ea7bd1ab24496265fb8cf203de7451ef6b77a69822becada3f0e14047"
  end

  def install
    # Set `vendored-pcre` to `false` unconditionally when `pcre` linkage is fixed upstream.
    system "zig", "build", "-Dvendored-pcre=#{OS.linux?}"
    bin.install "zig-outbinfastfec"
    lib.install "zig-outlib#{shared_library("libfastfec")}"
  end

  test do
    testpath.install resource("homebrew-13360")
    system bin"fastfec", "--no-stdin", "13360.fec"
    %w[F3XA header SA11A1 SA17 SB23 SB29].each do |name|
      assert_path_exists testpath"output13360#{name}.csv"
    end
  end
end