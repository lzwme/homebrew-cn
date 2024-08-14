class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.6.3.tar.gz"
  sha256 "07f3dfce2b10d0134f208d34ad46f123dd826187ba9d37ba81f0335d017f6fe3"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aafc57526fbe52b54aa5d2361ea167390f4e84057dc5b4dd6563ac468e3568c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22c7b2df661656578b78cea6af21ec2a074d6c1ce145547e386b14ba80778c62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ac613cb00815f62990607027ecdfd7a54a2136785c088c92c1bfd22ab795516"
    sha256 cellar: :any_skip_relocation, sonoma:         "29fd79c6be65c72ba125ba4dde6deb77005b2243ec679ad6e8be3f57bf9f0e0e"
    sha256 cellar: :any_skip_relocation, ventura:        "ba7b2f69e00f519a2d72f1e5e8ff9e9c981213b84f8099c5f8eb1a3d53296473"
    sha256 cellar: :any_skip_relocation, monterey:       "9602686c79aae38ad4f356fa02199ca397ad192222d3e42ddeeba00f1875c5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b186ce52a66feaf5370c2d8eb9ff02f568bfc483fa14fdef2ea7399b76bc1c"
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