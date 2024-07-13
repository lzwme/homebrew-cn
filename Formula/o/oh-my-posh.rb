class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.25.0.tar.gz"
  sha256 "ab389a2c7118811050f2afd9ad92e4edc224a55647c659a8419c7dfc8e229be0"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c7ab86d8f332d0c585e10f6cdd7bc0f83e2a43560a6d847df7cb4113047f3a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22cbad09fb33df5eb314fc25e40bbf59605e9d2ef67c5876f76447643c27055b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ad766fc1851fd642115693e1b4f02c24251e9d36d4263a42b467c1df1b00e14"
    sha256 cellar: :any_skip_relocation, sonoma:         "f27858885fcdbb740f998930139dc61b90353d8c203d8b714b5c1e2958eeb6f7"
    sha256 cellar: :any_skip_relocation, ventura:        "0d5211506820a8a351f6bfad7e5c0670a902ef895334f638d2e60f57e47a8e95"
    sha256 cellar: :any_skip_relocation, monterey:       "12a461e08794f1ed3a300b22cee6b11fe8360e8ba4a07ccfa21d0659e3f9aa24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c50767d3204de870de037b41862ca08f848c0e021284e492151197ded813afcb"
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