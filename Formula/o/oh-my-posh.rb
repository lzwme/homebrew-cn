class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv20.2.0.tar.gz"
  sha256 "726cc57dab590f99f033a13a6353d6d47ae7632d61b1ae35c44c32c38f593f05"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9cb46f0d7c50b6aef0adf7db5f7caea2fd3ab94fb3f1e0c2dd717d1e5ee99b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef55f0a21931efbe3d4744fffba8a0941c7f70fc55f1c4ed228a9abaf3d82565"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c72009c312a95ffedcd995e6b10176c8d96d6728ed049d4fae98c5dbaa6ad354"
    sha256 cellar: :any_skip_relocation, sonoma:         "e24bc292afd9110f26517274770f06fab95f57dc689e415451a95e2ef5037276"
    sha256 cellar: :any_skip_relocation, ventura:        "9d4044621c76c9d5df38500bc013cef64a5b3dd428cbea68171d47b7d716b358"
    sha256 cellar: :any_skip_relocation, monterey:       "c513aa54d4251ec58b71a6eb19e5344d8f6dd0bc58807ba6bc22b94143b2affd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f96f49eb05629d179e79ae754e64ee883cc8dca24073065a3e5c90a931f35697"
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