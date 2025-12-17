class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.50.2.crate"
  sha256 "562d29d45f0d2b4dd6c6af6165676028754165b113c60ec028d385b94291dd6a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3ea77d87842c343c697e9f08329b3017fbdf0b25361132c770e7dbb07bed6e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27d1f3864ef594cfcd5be86d0d46667905ee26d69c3bba1e5e5c0b7ff5d79f86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9efa467de3b3c568f26b8c43163946317ade68a705d0887bf332de32613189e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "60dfc749e063640d43a40cd38b3abd2e5b278b28f61594737024d4355f3b7eab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4e9b09471b94bdf4572dd0534397acb5511ff3e2045963c094d6c9fcbe43dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67231b4d52bd3369ba9ec1c20819ea187e4137efc4d065cfbca094fd1f921051"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end