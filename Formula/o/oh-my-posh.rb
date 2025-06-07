class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.4.0.tar.gz"
  sha256 "9c3d8358cb91466985f269fd407d1302f2fb7f9e46fe39f9f9a76c2fbf2bfa68"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e33538e016f93587f4baf4bdcf36e7bb32fcdb272162c03f42140e41fa1b03f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a87573e906b04d08cc6f42f6d2018310c90df5c275e7fb345ecfffcabce65dfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7f4f75724a95dbf40b62ff28fdc86c73cd52138cd4bbb8a2ed14e9c9f0d5058"
    sha256 cellar: :any_skip_relocation, sonoma:        "638f9019bd703eeda167b99f2a8bb110162622a3c457ab48e903b4c2583a0897"
    sha256 cellar: :any_skip_relocation, ventura:       "bdf452b07e32c960b350f449f9a7d9a820f8fe3a500e3ef536f8a83a6aca405f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a437c3b97579e3b80d5b14daa5adb78053999b0084b4da9c6ecb8fb55459c8"
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
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
    output = shell_output("#{bin}oh-my-posh init bash")
    assert_match(%r{.cacheoh-my-poshinit\.#{version}\.default\.\d+\.sh}, output)
  end
end