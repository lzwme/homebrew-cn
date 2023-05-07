class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v15.5.0.tar.gz"
  sha256 "188351215dda319ca07864307fca1383430c484ca93e1d4dd9750a4e2c1f6247"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94c02c5e84c2c7b732c1c539c597c9f754524aad278f32fd3933da56f388d1fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe8f72b4307bea41065b5cafea9e9e63476624b6ebd7352a0edb1e5a8a62325a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68f0a15b03969d674be4186e99da4e600d0096e6953c442d0d5d74b23b6744bd"
    sha256 cellar: :any_skip_relocation, ventura:        "957a42c3f5da130582708f63363ba884b4582f1d6d35830a835152ce63e43dcc"
    sha256 cellar: :any_skip_relocation, monterey:       "87e9628d362fec5dab3be2bafd090d4126bb6bbf6b6b0be6ee451b5c5082aca1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4bfff6b7f75899d830edde4fc18e647a2bea9487320a3a5e3e598791f9b322e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfbb44be7f7588cd658394acc523a113291332ed3e950d43722c919206965cbf"
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