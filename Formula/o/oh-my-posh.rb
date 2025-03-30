class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.7.1.tar.gz"
  sha256 "b0dbf108ce4732828fe6fbb4409d33afa23f339f6e0f8dab75904dec1c792999"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a839d3d3dbc82dd128c65123e94d522237fb1a96ab64d3139bcce3005c1c3739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb462cf0e76da3edc115e6637d18e19802fbf6b07a0a96e50894bb4a10cab87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c74ed3a1df8a4939ef543d00ca3b7f032c5fac1c2c7721a5c6e5e35b658051d"
    sha256 cellar: :any_skip_relocation, sonoma:        "01d5583c10a84eb1daf1e9a0c70adba7ba7200f1751b177c8612e1955de83a60"
    sha256 cellar: :any_skip_relocation, ventura:       "62f9745a46a357b293b93ce983095bc8d5d721c7d64af3cabc480fed0a8644db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d45706070798574b4126c0e9ac799160bbe0198a92002a2b7e6a530974b0cd7"
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