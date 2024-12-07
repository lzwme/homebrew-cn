class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.18.tar.gz"
  sha256 "baa7c8e2a00ff9a1d78ae8f5cd0e289dea94beb0afb352bfc4975bab6ca5b4cc"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "e0299ffaa5fd58d1238cf4d45bb5e060f99bb7cc548c88d69734d3b53b9b97f7"
    sha256                               arm64_sonoma:  "2afce23e9937a98582e0bbabbc090603f8426ffd8a4d966913e31d3d2606690d"
    sha256                               arm64_ventura: "02a26a0ab7cf441af619d1c5c3675bdf140fc618a742e8ea8fd077669785053f"
    sha256                               sonoma:        "3568a9379f475fdfe8111eee88fcde4ef06580df239fc7983d4e739932cf57e7"
    sha256                               ventura:       "f660a84feca5fc4f0c8ec17872ba5822c991caec923b6fb98e4e3f0e3ea6c6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee53cb525f22bd8a95cdcae04a73433c02355efb50b915a67ecb6378323237fc"
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