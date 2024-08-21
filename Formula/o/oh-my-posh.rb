class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.6.7.tar.gz"
  sha256 "2b052b1d2598658cb729c1c90283a94add29e84b2979ceef4d2ceb95573ab491"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f28017a7f30fa2e222eee01d8fcb826491dfce93b1e6b323782a2d684704812"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "548af697d36344b86a0e266612cf9dcd5f0c73542d319b6a4ba57f6b1fb6cb0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d0a31d333d9287a9ae1eeb544e4ded61e03525ccfbb2593f35b3544c5f4e2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b97e3f387348be349d83111fabd9bc3168dc6d13f270ff00c86b6b41326c33c2"
    sha256 cellar: :any_skip_relocation, ventura:        "8b746169407a9aa1c1cb14fbf71c4a4942791e6deaea797850005a0fd539029a"
    sha256 cellar: :any_skip_relocation, monterey:       "7abb1170fbd1d67b7f6d98233512b030c5300e1872be125a16e1250a040c28b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f75d0130afdd26aeebdf1dceb070e41eba9c1691c1cc572a0b8f9fedee609b67"
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