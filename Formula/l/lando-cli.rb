class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocliarchiverefstagsv3.21.2.tar.gz"
  sha256 "2b930fa5c7cbe50396d147d3cf51f382e8a7312607f9dcefc04a4ad1399f4a46"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cc780f7afd14ba0bce986968eeecd8faad1d61c24f41603bcf998099b7095fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cc780f7afd14ba0bce986968eeecd8faad1d61c24f41603bcf998099b7095fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc780f7afd14ba0bce986968eeecd8faad1d61c24f41603bcf998099b7095fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1d6515baa628bd2c3666dc22d911c4d548af1f4fbed6b78bca410309b28dc62"
    sha256 cellar: :any_skip_relocation, ventura:        "f1d6515baa628bd2c3666dc22d911c4d548af1f4fbed6b78bca410309b28dc62"
    sha256 cellar: :any_skip_relocation, monterey:       "f1d6515baa628bd2c3666dc22d911c4d548af1f4fbed6b78bca410309b28dc62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cc780f7afd14ba0bce986968eeecd8faad1d61c24f41603bcf998099b7095fe"
  end

  depends_on "node@18"

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