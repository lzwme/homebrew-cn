class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://ghfast.top/https://github.com/lando/core/archive/refs/tags/v3.25.0.tar.gz"
  sha256 "77ff156676a8c9c2100fa56dc63c3678ec58a8c7d0b2c0d8fc554fca2a22195d"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "70d851f948bae8dfd06991a9fce15f8ad5b1dd65dd66c064b6605ad21a5e3800"
    sha256                               arm64_sonoma:  "26b322cf5b6d179dddd2a03af7190041f31a2b4100ce5da96e61178b17146e89"
    sha256                               arm64_ventura: "3fd6abe9f56192c30e433a88712e159eefd3784e30beaaed6821c1892fd5774b"
    sha256                               sonoma:        "fa41c75e1428ad271688fbf69b36588a954520915f6e79a2712d63f43db0eb64"
    sha256                               ventura:       "8c7dedfe83c2ef1ac1291477a67bee4aba75acd7ed867a609262f307e05ff39f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5535daaab57c2815af4e535fa302b778aad00e7aa758180c7e0b2f5de932175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5535daaab57c2815af4e535fa302b778aad00e7aa758180c7e0b2f5de932175"
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