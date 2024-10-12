class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.19.0.tar.gz"
  sha256 "0fb94d4fd5e6a1f75c4fd0a47f68dc3b69783639131cac96dd686896061c05e0"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e08126989cf4234cf39bd5fa6195c8eeebae7149a491c41dd700142685390dae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b0019418059c306cf0bfeb13e96febbc2a8cd4fbbef7084499f15677ddbba7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "805928a8a73f1bf1c308389d4b10d326de4ab43dd0020900288ddf2d827c01cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5251fca10d7d9a70bd54c2b1b8787cc4992f616f57e4b3b6ca13b117feb4a5b2"
    sha256 cellar: :any_skip_relocation, ventura:       "e013e966cb2acae17abb66606d736dccc63c9444fdf25fea82aaf2132ec6b2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b700897ec776941aa1015daa371916dd0e79d316e9bd8a52c4954b91efd6b5e"
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