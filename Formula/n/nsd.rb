class Nsd < Formula
  desc "Name server daemon"
  homepage "https:www.nlnetlabs.nlprojectsnsd"
  url "https:www.nlnetlabs.nldownloadsnsdnsd-4.11.0.tar.gz"
  sha256 "93956d90d45ffa9f84f8ca2f718a42105e4236d094ce032211849f1a12cdc158"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https:www.nlnetlabs.nldownloadsnsd since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https:github.comNLnetLabsnsd.git"
    regex(^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$i)

    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sequoia: "f1dc1057d967c55241155e9fbca1dfed2d84b9747d730276ca44930331937277"
    sha256 arm64_sonoma:  "468ab3c420d678472b312d20edbf0ae59bc123bafa3b1deaaa73a46d41901319"
    sha256 arm64_ventura: "42ddd971ecee155ff8a7ed9fb0f3eaf3ef1056503213174579edcc480af5d35e"
    sha256 sonoma:        "c42a49b9af5291c034e1e2c8722a18135c031940220628569e823396dcf12387"
    sha256 ventura:       "ba654350358dea4d9bee9a0c19ba7139487528c63e6ee98b5b50365d3f3c27c0"
    sha256 x86_64_linux:  "5998f6372bf1d7c24c72ec43331e1b69e3397d4f0ecac9a269886d846e34f6f0"
  end

  depends_on "libevent"
  depends_on "openssl@3"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system ".configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin"nsd", "-v"
  end
end