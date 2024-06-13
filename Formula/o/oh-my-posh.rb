class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.6.0.tar.gz"
  sha256 "7bc7c0a04a460b0b96679d8ae4b49a8eebc9518bea3c798845231b0fc754b4e4"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28f3dd5ccbc18887c8a3f9560987e3c53204e7be76ce7ee9104817f63362a8a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fc6de734fd9fdf956c2723feaa9b8f9a2ae0d79113202cc585a99af6ceba683"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d255613e464e72486c5a7329273b325ce360bb3f4abcfe62cb84eab390aa480"
    sha256 cellar: :any_skip_relocation, sonoma:         "d08e823fdb3a08dd6f6fe928eef24b206f82895303fd0281cb96c181bce9ea8d"
    sha256 cellar: :any_skip_relocation, ventura:        "84fd67fa6b62194dbe4e5a1b0fb2e206bc8203395d4698624f949d53910887cf"
    sha256 cellar: :any_skip_relocation, monterey:       "cb5e89a8054807a59cf36b5e10a3aa6529a27ac886b6f45c57da76d5ab15c5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199fd1ea4f0d8b3533712a2bf5156c3167264c763ab1ffc49d041d202647f52c"
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