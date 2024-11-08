class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.1.0.tar.gz"
  sha256 "21ae04bf4e5d2aa9a74d2b71e0bf3e03192d5c213164972d8f682b43064e7b8d"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "343ee198068b8bee8e8c270f46f8dbd37e174beca9addf9ecb4cc788d712198e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9c7b2975846135e0ba4470cbfbe342c4ca8c325607b5f7d07c4f8af1f802cfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b60e7da7bc5e8f5f401be4f6b45cace242bccb07d46e71e699b1c4533180704a"
    sha256 cellar: :any_skip_relocation, sonoma:        "56cc1706e709396275bca7f5b6ee7072cccc7da4981e2b88b210fa73f390c76e"
    sha256 cellar: :any_skip_relocation, ventura:       "4f7113cd50e0568ab37a7ccb4873d6eb28cd6fea43ec39952323970d89287ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3681514c0b88fe3d9c7ddb9e309f0c4a9dd0d0c1088a696881dca9680152fba9"
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