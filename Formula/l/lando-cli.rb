class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.24.tar.gz"
  sha256 "490760a0f9a07773e8821578e8f8e9520d93a67828c1d9d1bb28078fff8f0e2f"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "925ce562b77f1662ea8a54dae7b4467a88c35d5905465b689cd053e6b4d33656"
    sha256                               arm64_sonoma:  "6e913ee94ae11437b0e71b0b48ab3ca827b1a7f9626936a11b56c9c272747a60"
    sha256                               arm64_ventura: "9dbf9212f7c6f144e8545211aa791d8f3df2fa71e29b01dbd15e158ba2c1aca5"
    sha256                               sonoma:        "c5f2da575c0ea134b91a99f2234dfa6bb8a5c8bf9a32ffeab99028eefd25a014"
    sha256                               ventura:       "cee53e83aa077628055470d1fd288cdec461d54c4e948f46bd88ed5a6831bff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6176b2c8ac31de81fec54cefa8055b709e81ccddd02d85cf1cf308fadf5776d"
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