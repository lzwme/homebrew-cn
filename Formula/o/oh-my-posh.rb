class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.16.1.tar.gz"
  sha256 "6bfe0aa257ea0db466c291f68d6596f6e0884c51970e94869629562459ba5bf2"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39e47cfa3ee6d92dffad8798dd1fb4d0b5910a83281b01332b38082da9eb2b8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0fb4d37bba31b76ee7f97ce42d7988479d9c8bf1275ad45d0e7988d526d71cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d737d1e05f071c8360c52c5ac7b372a68fba2f8dbb30bcc41e8166a9989177d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a9996b79b77ec8aa7baf062ed143138c20e2ab6440083216affba7b39062de7"
    sha256 cellar: :any_skip_relocation, ventura:       "5be213c2e2aedf03036d0278ca6f95874e207a3262ab22b601d001743762af4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec83325aac2f35fb5cbfba494948d9fdd119972582081d843dea692934e6ba9"
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
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end