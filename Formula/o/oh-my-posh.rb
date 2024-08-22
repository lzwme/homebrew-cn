class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.6.8.tar.gz"
  sha256 "dbb83e21a4c65b770a849998b786bb21490cc538ec18ea7635b4c76a64ca9da1"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ba4e05810595c0a7f9f05b93f0ac350b8aa2958d968797ae638b1d1000d03a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cf7bc2234b7b81ff532ddfda6b535d9edc218b8190a4e8fa359f404bf5367d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0393f23dae50921c30052a4ef89671176f58c6184f5135bc3be5f762da68063a"
    sha256 cellar: :any_skip_relocation, sonoma:         "78d27b4146e9c3de052045baf7a9659f08c1e7c6f66e363e0343f2eddbbfcb84"
    sha256 cellar: :any_skip_relocation, ventura:        "0d8bf54ef820d2e752fc565f4286947cadd94d867800e8271bd54c8e2dc09201"
    sha256 cellar: :any_skip_relocation, monterey:       "d0bf3f7fb94eb60ed9d494c8bad92dc5c2d0b66c562b891408d8bee3f951d9fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c27c91ac2a3276029463e7fa58b4f2b87925c6a4fd06ee0e3f4d5c6e481d05a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end