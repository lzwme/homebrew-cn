class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.15.1.tar.gz"
  sha256 "ce41e13317d35d7a5b3f34605487429391a41eca77b2006edd11e9453432c609"
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
    sha256 arm64_tahoe:   "d335e05d8b3d7043f4124eb3285f6cd55a1f7a57dbae3b40c56b91c66eacc722"
    sha256 arm64_sequoia: "ff97d55f0ad7308c69a6aff93388ee579a154df947227abf855b742801f01ddb"
    sha256 arm64_sonoma:  "93e59cdea56f296856b8f1a20780650a18f3e83db8fcd9b89833da302a1c30f9"
    sha256 sonoma:        "946da98fc02f3f9f6f7d9dfcd6100c93889dccd396a4811c1db77a1ff0c464f9"
    sha256 arm64_linux:   "622bbedf1d4c82d69da99878b2ba1fc761e9181ad4f2b0197193486bcdd2354d"
    sha256 x86_64_linux:  "b78b45e2733d25f34501496c478b06f3d5a2456b3c4b5b3902a6faf132c21523"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dnstap",
                          "--with-libevent=#{formula_opt_prefix("libevent")}",
                          "--with-ssl=#{formula_opt_prefix("openssl@3")}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"nsd", "-v"
  end
end