class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocliarchiverefstagsv3.23.0.tar.gz"
  sha256 "ff6aa8020b7a20bcca9478afc63db7d6e69ec9068754ae927ed758c6926da5d8"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa68ddc62d3114b8a4b86c53972585a2b47330de41e10e24b2f37e6b35431f7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa68ddc62d3114b8a4b86c53972585a2b47330de41e10e24b2f37e6b35431f7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa68ddc62d3114b8a4b86c53972585a2b47330de41e10e24b2f37e6b35431f7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "020fcf2ceb0db54e1453c1e81b06ae3d8cb7c6362f3bc5bc200e7411b5895661"
    sha256 cellar: :any_skip_relocation, ventura:       "020fcf2ceb0db54e1453c1e81b06ae3d8cb7c6362f3bc5bc200e7411b5895661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa68ddc62d3114b8a4b86c53972585a2b47330de41e10e24b2f37e6b35431f7d"
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