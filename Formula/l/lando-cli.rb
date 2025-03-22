class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.24.2.tar.gz"
  sha256 "bffed3cb43029705e233342e03adc0f0b85e12aae48595e921b36cc1bced2520"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "6df812b2d2bdbafdf9c299acb25d9adddb482f18a15b59929273a5994a90bd34"
    sha256                               arm64_sonoma:  "d8c14b26566766f19b2e3554109f168e3bd82d13f421711d807f1a7a7d91dd03"
    sha256                               arm64_ventura: "2d502d2a6bbfaa6cc4787b785f7e47ed8ed605adf2ba3b2689ee1534d4212b8c"
    sha256                               sonoma:        "be6706bf278ca168af56b87b0b0b5ff4a69db08a24e76c259511371c8ec13492"
    sha256                               ventura:       "ce37c28cd41a18acbeffeff89a08a0fdd366d44bd3cb5994386fa0455745e635"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b2692e2ed4dabc9851dfa9e3f366c4d31b0ae4d02110c0826ce1390b1ffafc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2cf507cea01303782c5b1568f9d246bb9a0284ccc9229817bd4f7bc5c49f5a0"
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