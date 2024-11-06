class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocliarchiverefstagsv3.23.3.tar.gz"
  sha256 "2778536f25b152bce8a538291226944c53efc2899409bc31a26140730faebed6"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55fb80ff406d9a651643bfd3d6d0b0c510c7f48b747fae30af1c184469830167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55fb80ff406d9a651643bfd3d6d0b0c510c7f48b747fae30af1c184469830167"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55fb80ff406d9a651643bfd3d6d0b0c510c7f48b747fae30af1c184469830167"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfe5f7511cc734770e927e9302183d532345b56437468cb15d45f60be32ee59a"
    sha256 cellar: :any_skip_relocation, ventura:       "bfe5f7511cc734770e927e9302183d532345b56437468cb15d45f60be32ee59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55fb80ff406d9a651643bfd3d6d0b0c510c7f48b747fae30af1c184469830167"
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