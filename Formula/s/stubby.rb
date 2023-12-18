class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https:dnsprivacy.orgwikidisplayDPDNS+Privacy+Daemon+-+Stubby"
  url "https:github.comgetdnsapistubbyarchiverefstagsv0.4.3.tar.gz"
  sha256 "99291ab4f09bce3743000ed3ecbf58961648a35ca955889f1c41d36810cc4463"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comgetdnsapistubby.git", branch: "develop"

  bottle do
    sha256 arm64_sonoma:   "eec9c56666a83664194ac6612bba1c330a54d14ead67dba1100757fc303f8edb"
    sha256 arm64_ventura:  "ade3c36ec956feefe503081cabbb3eefb02e4dc45cb333433866e6bb46db49ac"
    sha256 arm64_monterey: "31e36e04775bf9c033db8519d2a893ee10f7a0b9fd55f394d1d6d9593a28bffa"
    sha256 arm64_big_sur:  "846901b552ae3f6146d058453b16094860e4cb330857b96dc5eb0d96e11ead0e"
    sha256 sonoma:         "3064b04c529f9ce23df5d0df80ac8aba0bbdbfaecd5dc61384de7dc38e0addac"
    sha256 ventura:        "9b09af1e56899b9069fa5141af931ca86086891d3dc434ea217f1ae2418f07f3"
    sha256 monterey:       "a215b86f3bd4cfcf9684b056db2ead9d59b76de0b9cc4ab6d08a218e4ab69f07"
    sha256 big_sur:        "f68065895579d27cda75d2d5b1635749502205922ff260524e5e47e62c01bab2"
    sha256 x86_64_linux:   "9be25773bc7f384a70943d6edf294174a59d901c17f497e3dc91c855cb00733e"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "getdns"
  depends_on "libyaml"

  on_linux do
    depends_on "bind" => :test
  end

  def install
    system "cmake", "-DCMAKE_INSTALL_RUNSTATEDIR=#{HOMEBREW_PREFIX}varrun", \
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{HOMEBREW_PREFIX}etc", ".", *std_cmake_args
    system "make", "install"
  end

  service do
    run [opt_bin"stubby", "-C", etc"stubbystubby.yml"]
    keep_alive true
    run_type :immediate
  end

  test do
    assert_predicate etc"stubbystubby.yml", :exist?
    (testpath"stubby_test.yml").write <<~EOS
      resolution_type: GETDNS_RESOLUTION_STUB
      dns_transport_list:
        - GETDNS_TRANSPORT_TLS
        - GETDNS_TRANSPORT_UDP
        - GETDNS_TRANSPORT_TCP
      listen_addresses:
        - 127.0.0.1@5553
      idle_timeout: 0
      upstream_recursive_servers:
        - address_data: 8.8.8.8
        - address_data: 8.8.4.4
        - address_data: 1.1.1.1
    EOS
    output = shell_output("#{bin}stubby -i -C stubby_test.yml")
    assert_match "bindata for 8.8.8.8", output

    fork do
      exec "#{bin}stubby", "-C", testpath"stubby_test.yml"
    end
    sleep 2

    assert_match "status: NOERROR", shell_output("dig @127.0.0.1 -p 5553 getdnsapi.net")
  end
end