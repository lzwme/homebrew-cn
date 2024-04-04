class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.20.0.tar.gz"
  sha256 "a9028c0dbe58680cbd81ad52d999917eec1b45f4379210375bb7b752bde94793"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93787de7c7bc35beb614dd0c4a03254f496efb545812180604e8e925e7da892a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ebeb3d8b78f3382c4c2d0e0791d87ce53dcd239f94ffc902b588f1c0c79772f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fc6d19d31455644693d7ea690592e398b835421c08a74f9a6f961526c2a1507"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f22ec8d9d3705b144cfc160943e551bfc9127a6f8ec4a0111e40edc20743a96"
    sha256 cellar: :any_skip_relocation, ventura:        "4c8601158efa1e3c630a41c150291e15c1406c5cd72ef42f48cd5b9db1bedf16"
    sha256 cellar: :any_skip_relocation, monterey:       "9e898bc8b939d2c81387296cbd2d8e73c76303c044ace0b391dcf28f37955cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "672fb7c385e6e86f6f9826f6259d2866fd17a19c7d849b40348a86ae784a2834"
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