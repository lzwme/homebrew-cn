class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2024b.tar.lz"
  sha256 "22674a67786d3ec1b0547305904011cb2b9126166e72abbbea39425de5595233"
  license all_of: ["BSD-3-Clause", :public_domain]

  bottle do
    sha256 arm64_sequoia: "05a58b175a4b15be423b08a4dfe786f19e2e67cb7d0319d414ab1938da5a024a"
    sha256 arm64_sonoma:  "a6e15f3501cde82cc7643afa516b86904f42ac6e113f6fe84a58869dd9ce377a"
    sha256 arm64_ventura: "30e3b2e8f323d95b61aabe2236d553c4e998194a351451059f573bddbf5ff85b"
    sha256 sonoma:        "ec6139aeae59037853aff9e649cfaca5109276f4707f860ca4438edc15a84091"
    sha256 ventura:       "2d3686206357190fde0786187e04076b5cff11112152e37ff32cbd10548f1b89"
    sha256 x86_64_linux:  "c1c661ca728147560f889847f3c48728de29b7948cc4638ff1301289cdb204ad"
  end

  on_macos do
    depends_on "gettext"
  end

  def localtime
    etc/"localtime"
  end

  def install
    make_args = %W[
      CFLAGS=#{ENV.cflags}
      USRDIR=#{prefix}
      TZDEFAULT=#{localtime}
    ]
    if OS.mac?
      gettext = Formula["gettext"]
      make_args[0] += " -DHAVE_GETTEXT -I#{gettext.include} -L#{gettext.lib}"
      make_args << "LDLIBS=-lintl"
    end

    system "make", *make_args, "install"
  end

  def post_install
    # Generate default localtime, from Makefile.
    system sbin/"zic", "-l", "Factory", "-p", "-", "-t", localtime
  end

  test do
    assert_match "UTC", shell_output("#{bin}/zdump UTC")
  end
end