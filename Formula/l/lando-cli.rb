class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.11.tar.gz"
  sha256 "ceffd506f1a9e40b1b0310ea090b89a083da29cb2cb84bb92e38da117ae1214a"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "5b6821abb0f7470f0601fc8d20e0d6c2608f7363c2068bf537a3911734b75ebe"
    sha256                               arm64_sonoma:  "f3ae808ab2f0a47046497922fcba148faab5ad232e21c9596ed159b409733407"
    sha256                               arm64_ventura: "85209821dfef3d5cb9ea3d710a05ce085d6764e5b1b6936ea4cf62390d6eefb2"
    sha256                               sonoma:        "e414bd219108ad09800d77f81131078fa30596c8a9f40e53061555a2abdaf9b2"
    sha256                               ventura:       "331094cd35bd901f719cbcd28a6133e9a3f839fc977409b0ff354f59c9a34d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39d333e7d506ef35ae63f4048bb6296b83570b24c842213ee1814c7559288715"
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