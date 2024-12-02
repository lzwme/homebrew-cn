class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.11.4.tar.gz"
  sha256 "c3f79e2886ec4a0b0f0224dcb249f999b97356a65cdbe187edd7a7d907c06776"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "349f171c2bae2d972d991ea24a9a27916b61ee56a23cf54c5d28e3916a2c98b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fd43bf235c51cd206f4a320a08493aee10abecf9127a36886db65443423aeb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "674aae0a37a51f984481c16827fce3be91e788f73b065d0f9196003e2d456c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "df322f5af7161b733e59e6a23673aa7a5e0c8b8351cb9b669c5d64b4091eb6ef"
    sha256 cellar: :any_skip_relocation, ventura:       "a32deed5f6873187e5585b750588b8fba81f29336be5787f91d5d6eb2735ca3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062259d437dbbf35a1354e25d69400d9de99d21d49ef2864569d58eb3faf39db"
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