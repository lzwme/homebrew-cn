class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.1.1.tar.gz"
  sha256 "7d87c21b3c9dbc2848273bb53a62d474b40ebaeca7f5a8e056405a2f46657fe3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a15b7bb1c42bad023bfd8f3cc8cf07c4a851259d5d75538f3da3b9c14e76bb35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6be4600626c419155e210e7ed40e9308a587ea97b4ad43d0f8bb3b3e45c791e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36b1cbb27fe687ecd0780722f1bb1f924526db22adb2fd2a48d52d347bc76e84"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b48bfdcce78c556baaf0b804f4f1ec738caf159dd73ef0f42d85bbe8578d5aa"
    sha256 cellar: :any_skip_relocation, ventura:        "16b96c530a0b3ad2959a2d9f51cdfee2c9c45615dab4ed185853e2aff7f5db08"
    sha256 cellar: :any_skip_relocation, monterey:       "086cde41f4b1ce9e48a7d7a61b769faf8741cf8d560bf2e4813233968b81eee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "984165bcbcec99eded8c15ac04306d7069b4c8ea3f4e92dbd840ccfc246ae4d3"
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