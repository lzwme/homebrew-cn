class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://ghfast.top/https://github.com/lando/core/archive/refs/tags/v3.26.8.tar.gz"
  sha256 "03347869863605bad123b48660c3a3429c97fce92020737cf195412b604f3c85"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe7601f34cce01677435ebd55899f56f9250501b11866c6541b6870c7658ffe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe7601f34cce01677435ebd55899f56f9250501b11866c6541b6870c7658ffe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe7601f34cce01677435ebd55899f56f9250501b11866c6541b6870c7658ffe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe7601f34cce01677435ebd55899f56f9250501b11866c6541b6870c7658ffe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9b8ae302fcdd533b6b980f14cc7dc37342d17a919428fba5702bf5a3adda16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9b8ae302fcdd533b6b980f14cc7dc37342d17a919428fba5702bf5a3adda16b"
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