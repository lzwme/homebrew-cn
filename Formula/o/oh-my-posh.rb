class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.6.0.tar.gz"
  sha256 "5d7ee8a1f20fc32bfad60f575e2b3d5713dd8e6e0f9812c4b61cdf2954858978"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eea83c7bef90643545dd0edb4acdf87b2c312a6ed58e5cab4093a1277bf9e3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "723494200548c4506e5032c23022fa0e9078a34d59b519819ce3a32e1e9be770"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f9624b340dcf8d44f660dc7bffb5cf1432836dfa5cfa68d176da3f12875c773"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d3ed5c444d280a72c9f17e916fb7317b89a959c436766c9b4fe99ec710bf60"
    sha256 cellar: :any_skip_relocation, ventura:       "1b9f48cc280f03cb2dd1c3f6c7e9a36c4dd8cd182406b9d18fbffbc57f880ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a9b474807433eecf443d690db3ef0e858cdac18f3a44b99c9ff2e00c3c1d83b"
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