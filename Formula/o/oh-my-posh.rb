class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.10.0.tar.gz"
  sha256 "5578b151c6b5f62d0f04bf00b5199938406df3c95257f1f1c5e02b2559df381f"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70d5aedb179c642064f4e4f0c984a75b97ea90d16a22eb8ecc9896f860aa59f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e4588b54150c051861203134bc1c91a2dea7cf91d97633805cbe319b0e07529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0eb657153da122cd0a2026021fbf58f2f7d3cf29d9997784a49e1d2f265ed72"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f1b138299207fadfb4dbe68638015d189a9fd87847f81576c78860a9a2dcc4e"
    sha256 cellar: :any_skip_relocation, ventura:        "d8cd636576ab09df20b1590df970943cc7e54a8635976012cbbeb3c982459e77"
    sha256 cellar: :any_skip_relocation, monterey:       "5c6347cf56d8f8b23fad7a6720eafb668d040a7cb01866e40e00dd7d7a677172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25214cfd0ba83ab6b569c806720d1b8c8996ec7a606ca1a610af5a1acdeb4d7e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end