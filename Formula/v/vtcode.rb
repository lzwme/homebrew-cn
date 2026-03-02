class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.85.0.crate"
  sha256 "ab4b43574ffc646567c27d135f10af3ffd4737038569d3ff6dde90307b48f29f"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8be9faafa0228d57f4ff6eecc6ae8902953600a81cf3e609eb664f551056652f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4528af99658421c174b3debe4bdde9b42243e26bb560dadac3a7349e634ffaa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e380840992b47eef45288657715ac4d3d02d646f2ae5fd96aa660ba105c7ba8"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc737872fa88b1d127d6e066c06137fa52e71fc770ad1334936e12c7055689ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa10a84aa92c218fca0f5aa7bb27072ccefb0c6704ac01c800a2b7f0cd9dea08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "888f2cd70a1a4cbfb98bc0dc324e3dfb0e36888e4115509ae526b798acba819a"
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