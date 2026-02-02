class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.74.5.crate"
  sha256 "00ff07bfec2829276d679b0caf05de5fe093c9e39373bdb5c07ea7d88653c668"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da88e2145683ceae01eee85f77d567250d121f4cbcacb2919dfcdb50205b7dde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bdc52a00ce7bd3d87dd091b80afef69df973efd49ca1b7bfeb5c0aeb733afcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0f932dc6ef5dfd37676403e5dfc6049791d83d64519cf9c83116e6e2f33b009"
    sha256 cellar: :any_skip_relocation, sonoma:        "51babcd415a0664ac3e12a0f7dce8a92fdf7d5ef36e4e0064f4338aa15edb6c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faaa57562aa31075f542fbef0554d813caccd842ebad9c55f3bd145f5ad5da61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0dbba49d2d2cbe97fabd19ce72a3dbf3d7ec53b52218e39d7ec19f147094d98"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
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