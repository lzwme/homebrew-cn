class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.21.tar.gz"
  sha256 "8b19aaf9b754148a3cbc393662eeb656c088af16f9e3f7ee09a03733a6305e89"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "eea8a4abb66a551a3d12d9a6ead30ea39248389f2329d6cd6164c49747a4fa2f"
    sha256                               arm64_sonoma:  "d635108dfbf7448d804aba6489a7084735884d4a68aaaea1313583139215d2e5"
    sha256                               arm64_ventura: "564686df9369d5e82e739c75478b4afa60925b0a5befb460924562221631268f"
    sha256                               sonoma:        "d945834c6921448be58705cd464ec81917f76632af5f0027b621aee886fb73b2"
    sha256                               ventura:       "78c35e525db1ff63279acc4e91316543757e359d806c2940650ac8c0e4cf41ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c81d0b5487dc1f5d2fc9ece5f134ca85d3432663facd9b057010de91680146"
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