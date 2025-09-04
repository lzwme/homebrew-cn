class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.13.0.tar.gz"
  sha256 "971380b8c9f074b44cc411321e83ec7a1a3edcdd6fc06851ef20bff40685ec5c"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)

    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sequoia: "6f6d45074090c93c8f694b85bb930a2a3d6f52ea2a08b363f2481d607952dabe"
    sha256 arm64_sonoma:  "57da4273d982560d1774d916491b6b8a3a3e6ba4fb25af00e60fbaf89be4a05c"
    sha256 arm64_ventura: "671f15f68a85c5483ee5de1639018ec6e5e4dfc1cee9e4c1dffeb14627074fc5"
    sha256 sonoma:        "1199b90e4c76d3b478ef98b715014b80c8e85ee85e0818ed7f1abe553723df5c"
    sha256 ventura:       "d95615b42326cd6cf06a355a276504f6e26d1fd8c789d6836c8f19f468ab228b"
    sha256 arm64_linux:   "78ff71233e18360e913e457c8577ee1203413cf877cabb8922a236ee0c8dfecc"
    sha256 x86_64_linux:  "25563b3dc1fc63b6e94d6fe338054f4e9966ab41ee9a00ef8f61873fbca8f88b"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dnstap",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"nsd", "-v"
  end
end