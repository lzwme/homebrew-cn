class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.94.0.crate"
  sha256 "96a77eb498b34f36c8b0c7abe210500b3dcdb9463f580a1eff5ec32442bc7914"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b97d138670776838d6dec01bcec96e41a45141a460028c5aa633100dee7c063"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3447d952952988b3c44e6d69745952a376572c15e756f82b3da3a1d899b905a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d94db5557d18be1955c3cdb381c73dc2dfcace82a29dab60d9912385e2320b82"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf864ec05256be4154779e41c425344796dc85a953e66593a79c03468098116a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bbd09c891b3b8570911b8a6a36fdd791530698501131bb3c97c60ca96d25949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a493cd997ac3aa692f2b8b3606f0c94ac920e8ee7f09613732e5ece566336876"
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