class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.24.0.tar.gz"
  sha256 "7f460edca60fcc1e0656c4b14d7cb170932e808f1ac55d153373421a6f831fd5"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68442b1c0589208ed53e7ec2fb887a0a270c7692b6b2241a279cb01881a0e0ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "021d0ce891365f2afdcd0d2f44f97c40dc116bd0062b27c4c04eae3b63e0e556"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92e52f5a922d53f1abc22ed14cf54f6fe70b4db9b5e5829842d4c4a2b3ade052"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ccca3fcee491c8a60979d4728ddac7222c834d4f3610da7f09a4d33ca3cd3bf"
    sha256 cellar: :any_skip_relocation, ventura:        "1ce79dd9eeaa06a3bdbb9d596f70b0b4e71cfb30f2f1f017494bca9ae4030ee0"
    sha256 cellar: :any_skip_relocation, monterey:       "59e4f56259eff25b7c2a9e002935d658b29c119f3cac3e2798c7e5dd514a1bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24a3002f6d0475b60eab12e94a6ccff04f370fc8f509f67e8364a1d59305ce74"
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