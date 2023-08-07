class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.3.1.tar.gz"
  sha256 "8d263b912c38436e2ab2971925653646749c57de1cc8080f5988221562d6ba13"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "178cc70a7765008da6c1c27c6565ee90dd950499a56b7bddf7c690819cbbf7b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fcdb1c7b8406e2f56c213ad50cf08c41f986298fe75fad72581ed3c03dbf426"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b39bca225f5bb2f7dfabb9e15fbfc8b7acdfc1b028be18cadbc5e27cc192de3"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3a8af69a4a878348d9643696c334c0682a2f7c4eea398bd86d597352a1e29e"
    sha256 cellar: :any_skip_relocation, monterey:       "f6f751cc5d1312613e4dce1e9b0c7824e9ff867f2d193bef85182c90c59162ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "73c979885c731186d5deded6b9259c2f36b757a6aeb1941ad12d3d0505ded577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8ae72f90294dd17dd6f32b00d463198e839e163d44b7348ee9c2832ae4fdd29"
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