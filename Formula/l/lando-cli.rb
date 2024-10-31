class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocliarchiverefstagsv3.23.2.tar.gz"
  sha256 "32901cf30b1e8bd44a206879f881de24aa080b094574e268596252be05398c2b"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27262f91087973c790e2e67183836a75e94089383ed4c4f995b4e538fbf92c87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27262f91087973c790e2e67183836a75e94089383ed4c4f995b4e538fbf92c87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27262f91087973c790e2e67183836a75e94089383ed4c4f995b4e538fbf92c87"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ce82b4149d9027f9b58722388d413eb2ec10cdc00226ec6402751f698fde274"
    sha256 cellar: :any_skip_relocation, ventura:       "1ce82b4149d9027f9b58722388d413eb2ec10cdc00226ec6402751f698fde274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27262f91087973c790e2e67183836a75e94089383ed4c4f995b4e538fbf92c87"
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