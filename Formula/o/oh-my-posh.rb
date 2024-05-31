class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.0.1.tar.gz"
  sha256 "8ce35d66239ed1c6764e52c1d1e429d5fc0cf920f2c7b6bb6d52644dda5426ea"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6de371fe8c6917e061609ddaa20432d7b6eff5e75a5c47708eace20c62bd7ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a119e86e6f7b68b3976d956c8173e0720fcc11a1d3eab2375660e7ef364c6ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "260b6e4c83d907ffc511ec12af9e47336f480ff661fb8a1a065382182726c9ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "d74ab8c588fa53df611767f293c0849761febecb5f8063e00d8007204bc714ab"
    sha256 cellar: :any_skip_relocation, ventura:        "dc7eda9628cc4b5c4f53f9ec99cb636f7410316b9ddfb3fa74c4a2626d5175ab"
    sha256 cellar: :any_skip_relocation, monterey:       "2629403921fdd527df1f617e6b3a2b74bbc0bc81fb778baf78fb25cd97fcea39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a476d13507cc9aca7591c96deb8bd3899f44f9e49589a02d866d708262426041"
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