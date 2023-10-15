class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.13.0.tar.gz"
  sha256 "3e7f3345a0dbb4fc0458b14b03966ce6db5cf20abda873f29fb71600e4a84e81"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a00e71bde39092d997f7147a41bbc066428d6f95398be9463fc2b049fbeb1bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37d6b14ea5ba95f2404a62e05c03e47fb42c9a309686c44d41288c7a278415d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "212a999b4ff0fbf79d1e3984379933da57f2a4a983031a2bce9ae3f00aeb2f26"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b440405cebf0faaab1c1089e158bc73065f496e040fb2a546bebcb8f5f84aa8"
    sha256 cellar: :any_skip_relocation, ventura:        "13b77e4322539118a91114d29676f96b1a4c583a9e29b02e9f8ff4f37d94b9a5"
    sha256 cellar: :any_skip_relocation, monterey:       "2d0a5fd59626a7fd224d44d0c75e6b3d652a741956f414f5eda693aa97ceba03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e44f1df306a6a8a1fc9c459523e78e30b1015d87719b8813c5bbb1125015d0fb"
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