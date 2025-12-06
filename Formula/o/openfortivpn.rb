class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+TLS VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://ghfast.top/https://github.com/adrienverge/openfortivpn/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "d283cab457c326b7b841c707a67b8468be097b732d9a13ea7fe8ad8ef120a3cc"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/adrienverge/openfortivpn.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "ce4bd2e78dc43a92294bad4397404c40cf70f9646e0a9c6f308323126a3b8c58"
    sha256 arm64_sequoia: "c4dc07311411d56783da5b1fe2ef485dc503e1de5672e2dd85bbdc410b0a082d"
    sha256 arm64_sonoma:  "e3f005ffd8380e273bcbbaf39bea90eee5a42e64183dc0bbb1011626efea23ff"
    sha256 sonoma:        "ea8fa84204a9f171f3fd9e7f55717e50fd498ca6afa8d972785faddbd8b157ab"
    sha256 arm64_linux:   "f9462bfdac99e49a55901959892ab797b8f000eded55c12002bfb18403e9182b"
    sha256 x86_64_linux:  "02c02057b1eb8aad17f6729b999950af20a18e3217f5cc76071eedc680a4655e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  # awaiting formula creation
  # uses_from_macos "pppd"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-legacy-pppd", # only for pppd < 2.5.0
                          "--sysconfdir=#{etc}/openfortivpn",
                          *std_configure_args
    system "make", "install"
  end

  service do
    run [opt_bin/"openfortivpn", "-c", etc/"openfortivpn/openfortivpn/config"]
    keep_alive true
    require_root true
    log_path var/"log/openfortivpn.log"
    error_log_path var/"log/openfortivpn.log"
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end