class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.13.tar.gz"
  sha256 "1e5dce3fa35f661a590ca36d36b73a6d7cd07bee9c2ed5eb4d3b60ed1e6ba353"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "c7681748cc01247cae83bb007f5df2cd98760043c6df78863b77644be91d32f1"
    sha256                               arm64_sonoma:  "89a71ba30516e7d3573ce1251896d31a2737ff79f1d81285c9d26043da4104cc"
    sha256                               arm64_ventura: "a387ef8dad0800ed25045efd7f3e8ab588d9527430ced24b009a47733f10764a"
    sha256                               sonoma:        "db662412314b38c3ceab50ddb84cae9b658e495b5ab1bb8a06a282f54fe61f42"
    sha256                               ventura:       "1f4d40e40c96a2d1ffbedcae27e0c8756e929c683f93d8eb64fe7b32908fe91f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab2d79e3073d559e48129a39de0c4f2ec8c1d5e089a6c1de258de6973b699da"
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