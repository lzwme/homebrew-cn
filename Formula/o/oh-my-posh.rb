class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.5.0.tar.gz"
  sha256 "22e91ac5367985f921e2e37257004c9a137de3767ca5d139a695aa45e36cd65a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5a9a36aac84ace30d173a5c91f7eaf3824d2140dbdafa0b84e3b3627f6d0872"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621dc8c46585c16c9d5922974e6f3465cb6c82ebebf37e5174e76ce5b7215a2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16d96d48916615f60e004b4067d7e3da203708fb9d4f98289a1a45aa8358e715"
    sha256 cellar: :any_skip_relocation, ventura:        "f68bb5d527ee41fa555506d36ef912cca793bf32b660c74559c7501d641f6977"
    sha256 cellar: :any_skip_relocation, monterey:       "850ccf55ba7fb8a3e4f32b3dad142db48392dc0af7101abe699a9dc7780b6fb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "13e546754cf5504e815284d29fa0e5d48073b84a0e28652aa4f92587181062f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "030883009784428a5ef839d10496e83758eb38001a246f5c98827c94bdf167af"
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