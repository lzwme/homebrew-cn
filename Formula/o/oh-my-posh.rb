class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.8.1.tar.gz"
  sha256 "8df1026323cde821b15da90f5a0b7873844ebae802419d8287a4bff7dbe39d71"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "894ed7aa41dec2cded90a0c047926ba542d079d28a551ef8b76170b1613be42e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b12e11433ca74f97aa990ca4364512a705882ac5969b2ad2bb489bb430b66b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1705a6f1497fc70d48fa76c36fc66cc8b0614a177139e421190171b892ef574"
    sha256 cellar: :any_skip_relocation, sonoma:         "df116c6190b85a8eef0e26d8335bc8cc4f81428111f0a2633b6ad788a5c687de"
    sha256 cellar: :any_skip_relocation, ventura:        "c12bcd37a64a7d4bd1e208d3a41e83889c46b00e0df942067953f798b878667f"
    sha256 cellar: :any_skip_relocation, monterey:       "f27a6b4d5e48bf4eb31030eef9359adb6afb88c713abdfb5b2ad44be9ae9151c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc15559beb2af2efca0e9c696f0c5f3790f5f00171ebae5e7d4a1d0a74f80917"
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