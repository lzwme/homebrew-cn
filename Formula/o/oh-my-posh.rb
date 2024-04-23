class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.24.2.tar.gz"
  sha256 "eb59e2ff2b8a1f532bb685df4ae700a2473b3b5416b686ce5588bcbd3fa5f02b"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98403431967d4270b38c4ef41d1ead084ee6eb8b95bdfb542209d604b41b7568"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6b4ac3acccbb9d43fa23d5b1ad2f650b65a70757ce46cb7408355292af642c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43910bceecf9ae2d214459059c75c9d1db025f56079b11da55ea0f6447a46af9"
    sha256 cellar: :any_skip_relocation, sonoma:         "58f7aa0837127214c0ed01ca9b99e4417de585e97b7dd4745fd0cbf51de5cbd6"
    sha256 cellar: :any_skip_relocation, ventura:        "f661441880fea57adfd6d746d29daa14f9bec27b693bacc44af9b490f3ae4b45"
    sha256 cellar: :any_skip_relocation, monterey:       "2137eeb201263907a6a34cc12edf23b9bba7f1b33478bf55b7d6a64477660536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53364a74e89873b3f1865d78075ed387be57faa67e220337577acb1dec713596"
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