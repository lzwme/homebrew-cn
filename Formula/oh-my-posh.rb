class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.2.0.tar.gz"
  sha256 "281d27ea3f566ffd36b5a529e8e76a70eb5897d197e37a03a95fccadb53159da"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "082e7cdc695d5cd13df2de0efd3e7bb010fad04f7baf3e962364f8ad09ee525f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af0eb6c398024ffe7394204e77a3bbe9831c6163b4e1b2c7d62f1327bf57666"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8730dfdf5402f0907ea1a72e022a3451b6206e74d794c18f62146a0a4d0fd0fa"
    sha256 cellar: :any_skip_relocation, ventura:        "fd5e77801c1fbcb534ab54074618a313ad85ba98dd63243d23be6d0b51e9603b"
    sha256 cellar: :any_skip_relocation, monterey:       "297bacbb425768426804887fba3a03881012a0a635cbc2e467773beb563b913d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cdd6f588c55d9275a84d5fc6fae911f8ed0115e5814405890aa5398a42d30b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be66eb9463862135ae918b5019722b825fd7a4968b1942ab9bd16fc4462bf63e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end