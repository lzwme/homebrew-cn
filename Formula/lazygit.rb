class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghproxy.com/https://github.com/jesseduffield/lazygit/archive/v0.39.1.tar.gz"
  sha256 "c8aa39536287aeca3e31e049405fd217940d2656cfb84968df516b43cba06977"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dd943fa75fd39ac2e301a86b822ff73c8b3117d781d79eac3b3a4dc70f53b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dd943fa75fd39ac2e301a86b822ff73c8b3117d781d79eac3b3a4dc70f53b67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dd943fa75fd39ac2e301a86b822ff73c8b3117d781d79eac3b3a4dc70f53b67"
    sha256 cellar: :any_skip_relocation, ventura:        "336884a2e4dd81468a8984522aeaf60c2905774afb7be53f00317603b64becf2"
    sha256 cellar: :any_skip_relocation, monterey:       "336884a2e4dd81468a8984522aeaf60c2905774afb7be53f00317603b64becf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "336884a2e4dd81468a8984522aeaf60c2905774afb7be53f00317603b64becf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b9756517ab6a67fe7c8bce68edd2cf637f7ad25b4e62adca7f942c1e2292f54"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' to do certain tasks
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_DAEMON_KIND"] = "2" # cherry pick commit
    ENV["LAZYGIT_DAEMON_INSTRUCTION"] = "{\"Todo\":\"pick 401a0c3\"}"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "pick 401a0c3", (testpath/"git-rebase-todo").read
  end
end