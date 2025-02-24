class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.3.1.tar.gz"
  mirror "http://miniupnp.free.fr/files/miniupnpc-2.3.1.tar.gz"
  sha256 "6511374c31715b5a778c587539fdc1491e95ea07ef549f3a0a4f635812c918e4"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6014a79e4358d4371ff60e42219d2251128b6d58d8cf4d882272d8261996ab1c"
    sha256 cellar: :any,                 arm64_sonoma:  "fc098199e99a46a9ddd66e79113addfeb1abc93924a302d37268486b5bc843b2"
    sha256 cellar: :any,                 arm64_ventura: "fb4bc0df286fbe40dad2ecc1aa43a4ae86154e19e7de3484839fab7b8f1d15fa"
    sha256 cellar: :any,                 sonoma:        "361718accd0f980894b2e78ad8406cc95adc04d09abaea8e3a7ad94648d9dd45"
    sha256 cellar: :any,                 ventura:       "03c9c0524fbb6a24c1c2bf049f74071814dfa3cf40f92615dcc5bd98b179d7a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69caecc952d80cde667b22c90764a666f2318e992a73f6f7bd9b69f9c7f78f9f"
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    # `No IGD UPnP Device` on CI
    output = shell_output("#{bin}/upnpc -l 2>&1", 1)
    assert_match "No IGD UPnP Device found on the network !", output

    output = shell_output("#{bin}/upnpc --help 2>&1")
    assert_match version.to_s, output
  end
end