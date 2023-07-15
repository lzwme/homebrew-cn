class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.11.2.tar.gz"
  sha256 "e7f28d6051269cc0b66d2d8adea0c0fb5c0639fe49ad0a73d283b83b86058ca6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "920256a54edd3ef7d5ac453a03d8265a0023afe63df71fb04a56c8adb769a41f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f4a46b3ce794945be90adbb666786ae8ea007417c5afd5a7af6a5d06de1443a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec207ffe098fe2275357d5accb2b4354ce7bb2b33f8509e097b0c96d5571b5f1"
    sha256 cellar: :any_skip_relocation, ventura:        "a03630b78d39fa836f740d1b75bcd016b2efeabc357222e1213fc65a2ce29b33"
    sha256 cellar: :any_skip_relocation, monterey:       "14e46f167a4e6e2415d3a9a3c0b3a4df4c1b4ca6ae3fdcfc1f455480918a2d7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b78e6bc3937a510d682d1abcf8b52276ad2c78076e3d484ac75eaa4b0b1aaad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b3affd6c888c5d7ad20dfbf488c8de881f2996773f9400f8e33333ff8eed16d"
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