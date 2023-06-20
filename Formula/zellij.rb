class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://ghproxy.com/https://github.com/zellij-org/zellij/archive/v0.37.1.tar.gz"
  sha256 "8b780216532a3fc6151ce13c58cd482c285c208b23e19088576d98d3ff5c75b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b06a27efcbb61868ca51ed20e8043508150a46b5e4fb84c3557f94c9902e41a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bcf78b4c3afd6b897792bb8676686b0935124bc3fa9174822ada695fdd676cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "591a9965ae5c92d050f34351b86e0b7d0951cf27465a6a4b367741d11ff384b0"
    sha256 cellar: :any_skip_relocation, ventura:        "3d55c2f68b7437ed927ad4e8ca5c56765f61c6d0dc0edd066847255ffc3c2330"
    sha256 cellar: :any_skip_relocation, monterey:       "a6006756eb47b36900c69c214240bca1558ae37817123841b258400497155904"
    sha256 cellar: :any_skip_relocation, big_sur:        "a010a86304e0e9b7438af98459fbdb09e324067cdafdcf9599ece0895c262537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b16ae7df6152dbcc41ef381211e24c670e21da6f5ef57144c25bf95086d40308"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end