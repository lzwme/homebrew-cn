class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20240725.tar.gz"
  sha256 "a702a17e454193465b2f8cb9608521f8bcc2b0900ca6276cf6b6b0cc8033ef07"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a90477e111b0a715079144316f4e7400bdb5c486eb7f7f51c9f37b5cdc3d7a05"
    sha256 cellar: :any,                 arm64_ventura:  "bd2494aa5f9e99d0046cf319713b0c8bbb0613f495211b957c0471587366913d"
    sha256 cellar: :any,                 arm64_monterey: "4ea08029bcc73ff6b30518af8b0df1b7ad9d9f5144d2686d214c1992a2cfe47c"
    sha256 cellar: :any,                 sonoma:         "a71a71b84b91ccd5636731938a857ea5079570c4d802a5ef93c2e6399f5c7810"
    sha256 cellar: :any,                 ventura:        "38916f78b5e252951888c2b9ff7667600d13f2732276ba4be7e2aa5a0650da3f"
    sha256 cellar: :any,                 monterey:       "df852e654a86c433e99a6c3e3bb91021c313038198de7960a95676965d9b47d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9125930ea8133f3cc51026c7444eee883f7d4e05a312375a02d44932eaf57736"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    expected = if OS.mac?
      "dl_bpf_open_dev"
    else
      "scamper_privsep_init"
    end
    assert_match expected, shell_output("#{bin}/scamper -i 127.0.0.1 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/scamper -v")
  end
end