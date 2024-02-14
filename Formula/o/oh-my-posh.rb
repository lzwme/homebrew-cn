class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.11.0.tar.gz"
  sha256 "a7fcdb730205bc1e54e8e5451e015051a4d86778b0301d1e6713f3130b6b3a10"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6fd4d32ed100844047ec36c862f2bf2be24b6a03eba7703ad8a5ae51cf6d01a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "309f949c2cd71989d688b04fe889da5d8fba6c17943eaa5fbfa9808e7119e9cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eafa29ce229fc88e6a1cb565dd95c2c9cca2a9c1f414d72fc241172db0a645ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "3527720b2e415b3c3dc2f07066bdae86b5236f2a71c9c964d31a7cba532eba10"
    sha256 cellar: :any_skip_relocation, ventura:        "523ca7b9da8f8f29461b21cf3dc4433f29e59ec10990f2ee963e162a2c9e451b"
    sha256 cellar: :any_skip_relocation, monterey:       "5fb451653f8cc2afaa19ef381cd75a4229d52b3e4f006ada0d300af6d3e8888c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dce6d4ff760a26f71b97dd4b39a3eb3381e54611bacf751e385c371d4a643387"
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