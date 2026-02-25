class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.14.1.tar.gz"
  sha256 "d3fd50a567551ccd606a11a05613e8b00e70686e3a98b9e95285ac045978f969"
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
    sha256 arm64_tahoe:   "28a450250950243d099ffa7f848dadb23153676ed3b4becfe5737a6f195a5c24"
    sha256 arm64_sequoia: "78dd22c237e228b419ad48af14b2819f7dad25a31e77a9c6f4b8fadd053d7c11"
    sha256 arm64_sonoma:  "e2aaf43e4e50a41662acac44c75420f5993bcf815fb5e3d6087b13f1264f958d"
    sha256 sonoma:        "95a51b8c1ae988e56b71c31e758b8b74012001e8fb3cdb680e7f91eac6075cd9"
    sha256 arm64_linux:   "31b47eb300a16bd281eb3b49279b405b08733e91fb5312fb0aa31c5623964267"
    sha256 x86_64_linux:  "3c202c95aacbe3ef1a93b2a8ba925c090888b1f3f88db06aa4296d302703bcbd"
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