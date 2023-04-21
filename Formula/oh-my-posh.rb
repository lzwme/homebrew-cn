class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.31.2.tar.gz"
  sha256 "341dfebc1058940e18923b817b79e12c52735831fdd94712fadca47cf8e79613"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f097d509e3e00bba9b08a42164ec57e56da0dca3074366a57ab4af06849419a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "604b93b2135035daf7fdd14afff1be5cabf27b47a19dce7d5e438b94175d5b0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b253bfab70de3d2d020e4dde3f75e3399ba14a9f0a3ca65e1d75d6b45884aad"
    sha256 cellar: :any_skip_relocation, ventura:        "93829c7028f922b0a23d8446aba8e5145978d8ee3892db765315eb2ebcb2ac8c"
    sha256 cellar: :any_skip_relocation, monterey:       "67876e1cce244f4dc3cab967695301e4b80ecbe8c796abefd597d7917009ea9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a9959c282d154f4da8a2b0212c5cd1bdf5941c9d093ea3f2e21b262135f58e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9089d4435e5c8316cee71e4658cda5ef4818ddc32be8a0fb189140aa2ef569b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end