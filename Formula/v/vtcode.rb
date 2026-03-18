class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.90.0.crate"
  sha256 "19f3b17ed735715aabb8d7072f2e1c758dd65e9c922368e8001867e87460400e"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bea648e9af172816a14a817d2d7067434fe2b798fa16142236518a3777f59e7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a23b814c2bb7fd13763c6bb10888e72c31516db5fa5f1b621e293534c45e1d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c0e8cd8f05359bba75ed3f0af4e9ab19b6e728b062038513a28e5450b38bc89"
    sha256 cellar: :any_skip_relocation, sonoma:        "75111c20c3613302695a50353d08c180dffff2264d6824485cd5b2b9fba6b475"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37466cdaefb5870568bdca415dc4f6f112be4ec2586db402e5d0044308607f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f690169e9f47b21f1b7f466eceebf733682d34461d90ac4e9325ab0c840fecb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end