class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.0.1.tar.gz"
  sha256 "58bfcf64af5c10c6e39ba6e6f608ed99e695bdb3940632a6bf38f0282d77ac09"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3edfc9f7d054afc188bcfce69de946b178e153572d00da2994e365dac81093ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1839c2063d54ad982e195815e513bb9341aac03df12fdc46e1780f7002678174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fee4c81c0b120d419dae359a14d9572f445a64a3f10ef3c9c6c18d90820b6742"
    sha256 cellar: :any_skip_relocation, ventura:        "73c54ec48d603639f24e2139fd6d07e60f27103fc930ad30fc9a83ddade1226c"
    sha256 cellar: :any_skip_relocation, monterey:       "6866283a786bd854263602ba84f777f62149775ab356f29c2ed09c0f61b138ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfd95ae8cd8c6fa7edbbbc69649b340b3cb0166a1561bf207540bbb10614d4db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044fde469881c76e6275859b74eca6d5b8242504f52cffa28322f736cd2bc6eb"
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