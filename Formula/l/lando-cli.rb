class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.14.tar.gz"
  sha256 "a257b8e7a34b19d68f3ddaf5eda49818225447aa7b939dd387c10bd1dbf79038"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "587cc410745a7111bbcc0444b53f3cd445228873f864ada7427d4aa62a227fec"
    sha256                               arm64_sonoma:  "88d95b6b3bb11131b11b9ffcbaacdce409ebc767fe7f078692c0a705b36cb461"
    sha256                               arm64_ventura: "2c3959ea0d2a38f5818b7589b675f235e3ca56c35c1d199476ab4c564ec1d96e"
    sha256                               sonoma:        "d5bdea373738f3867f2c88456e25c78ae7fc31f8ee40d383982da250737ebc2d"
    sha256                               ventura:       "cca9aa93695eb47cba047acfea510df51e15d676932cd0d4f10184b27fc2ebb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a57b2f38d547bdfe6d04219e0c5997de3e4dec93018619bd163801e59166771"
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