class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.12.1.tar.gz"
  sha256 "4774496c8049c5ebcec74af48bb26645d7501baf3187ae63d3d34215e5fc6282"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43e3dbf26fc0fbc5e6f24d3dfd15ae40bf8dee43b6d0b42ea7a81c4f7eddc9eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad7a3dfbcb89a667624bdac48a89891e1765eb181176f1af1a6d7677be96a1af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff6a7af68f1ae77bf35f8c8506937faf1b9a25d39ed9b8de7c9704dfd4ed5dd9"
    sha256 cellar: :any_skip_relocation, ventura:        "0ded5c39938e0adc7b09ffb0bcd6387414df4e919429180cdce7002065e3b049"
    sha256 cellar: :any_skip_relocation, monterey:       "be9ddb4357604f10fffc39901986a44227d33168b2fe70e3ac5aacee387fd49a"
    sha256 cellar: :any_skip_relocation, big_sur:        "35caa90423917f5901ba415515e1ecad74fc6395cfbde227e5eecb6d6507577d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e175961d90a8a1a01e7e706ba3563a2a90c3b9f30ccf7482dd43ed01b84176d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end