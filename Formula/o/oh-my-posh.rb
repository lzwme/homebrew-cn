class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.24.1.tar.gz"
  sha256 "5f09acfe3b92678b805bfa6e88768d4c68050c24772cab5b057ae5b6e771af48"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24786707d9bd12135366101523a88c19093816257dd428622756d37ca428157b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73549f6cf91b6a07ac5effad0673c0656eaad72fdd168b3a345a89fd1b8042c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19f8424a9c58acd74c41bd7e7ac40882c938c79ba08db6014128509e4b348d29"
    sha256 cellar: :any_skip_relocation, sonoma:         "20a5dd242161a6897fe5661dd6559270b25187d0a0263956f9200cdd1aac68a0"
    sha256 cellar: :any_skip_relocation, ventura:        "64fa31ebbc703715310f2b4d03f95b60a409118fce4b66a6f852cb07d6d43201"
    sha256 cellar: :any_skip_relocation, monterey:       "b0320a836e1429bfb5e2839eec8e4ddbed5133404a5bf0bf5a2ef497239da2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecbbca38098eeeff65a04daafc9a524f2d1076242f2f662d3b9c54519be9168e"
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