class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.15.tar.gz"
  sha256 "05337e30d92065d67411294e53cfcda7139876edf16716fc3db17340cc093028"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "61f94d5b9bc6f7da9f8309145e9b023dacc8e75659a8212682cdb983e92c3f09"
    sha256                               arm64_sonoma:  "28191b2a49ba75d5da34bbbf4cf587eb9599f5c2d851c352001ecc5a6ec7d5d4"
    sha256                               arm64_ventura: "490c524d1d6fd26560791e2cf559b27445d046b6c3b15ecb6d9b77f536de7b1f"
    sha256                               sonoma:        "a540859e4c918a2682659ff430d00c14edf79943ebf9c7db04748a21b35a1aec"
    sha256                               ventura:       "0d6363a2320b2c190e20d6d6aec8775b6af86e87e2881157872659ed2c5082dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beef2feea1c748d73e043950bdec8897ac26f09fe0f7c1f29acdf38af2b1df56"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin*")
    bin.env_script_all_files libexec"bin", LANDO_CHANNEL: "none"
  end

  def caveats
    <<~EOS
      To complete the installation:
        lando setup
    EOS
  end

  test do
    assert_match "none", shell_output("#{bin}lando config --path channel")
    assert_match "127.0.0.1", shell_output("#{bin}lando config --path proxyIp")
  end
end