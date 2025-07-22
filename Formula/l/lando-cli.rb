class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://ghfast.top/https://github.com/lando/core/archive/refs/tags/v3.25.2.tar.gz"
  sha256 "6b92b78c1f3ea33c0feaaf26d9091d5b44ef5a5adc051f7bb4a2eeef3ad8fc68"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "ad441a7a1418b7ad1a0ce8519dad08e5858176fb9c288f542b6c7dcd788c72b1"
    sha256                               arm64_sonoma:  "b65af6a7486b71b971eaf1eb96c7779ce695ecf2aa7f7eec5fd156642f6d5ce0"
    sha256                               arm64_ventura: "12d50334ac681efe7ce881b514cf1e4378aa3bfe0790c8ffa7a1739a27839f6c"
    sha256                               sonoma:        "fbe309e5fc8ea8eb33ea7d7c8d5aa733c22fcc118815136670b6431c61531d30"
    sha256                               ventura:       "aea4e28c6842785749f3667fca44568cb5441eb76cefdb2aa1f114e5528a2161"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4205ae595ae028d9ae842c919fb395c66ed93090d34467e08f9b81f9a0740114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4205ae595ae028d9ae842c919fb395c66ed93090d34467e08f9b81f9a0740114"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", LANDO_CHANNEL: "none"
  end

  def caveats
    <<~EOS
      To complete the installation:
        lando setup
    EOS
  end

  test do
    assert_match "none", shell_output("#{bin}/lando config --path channel")
    assert_match "127.0.0.1", shell_output("#{bin}/lando config --path proxyIp")
  end
end