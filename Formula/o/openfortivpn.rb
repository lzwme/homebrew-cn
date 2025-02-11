class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+TLS VPN tunnel services"
  homepage "https:github.comadrienvergeopenfortivpn"
  url "https:github.comadrienvergeopenfortivpnarchiverefstagsv1.23.0.tar.gz"
  sha256 "2372a3df304094f46b74e1103aeff693662c76e7448023ff0791748691f7145b"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https:github.comadrienvergeopenfortivpn.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "61b5a196081234f2222283087f08300be7fa3f2261390c9086ded2824d308c63"
    sha256 arm64_sonoma:  "b97fdae295ef860596749ff2ff9c7d29f92dbb781b49fe8e7cb29a710821ae18"
    sha256 arm64_ventura: "05af5db454ae63661c995ce6fe438f3008cbe3e80956b20b6b80b173914e9b3e"
    sha256 sonoma:        "d226b0c8864705dad86fa48ccb6b5a38367d3311ac27f237ec11971f9fdcf84a"
    sha256 ventura:       "4814f5bfaf64ccfc339b88f6e4a099c53310a87b33c546cffc2724acbd4f94ae"
    sha256 x86_64_linux:  "7e1938bde47faa547bd6d9b6d9f0c75612b8133c34c69ae8e4cfa1d0f1d03a22"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  # awaiting formula creation
  # uses_from_macos "pppd"

  def install
    system ".autogen.sh"
    system ".configure", "--disable-silent-rules",
                          "--enable-legacy-pppd", # only for pppd < 2.5.0
                          "--sysconfdir=#{etc}openfortivpn",
                          *std_configure_args
    system "make", "install"
  end

  service do
    run [opt_bin"openfortivpn", "-c", etc"openfortivpnopenfortivpnconfig"]
    keep_alive true
    require_root true
    log_path var"logopenfortivpn.log"
    error_log_path var"logopenfortivpn.log"
  end

  test do
    system bin"openfortivpn", "--version"
  end
end