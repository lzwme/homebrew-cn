class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.58.12.crate"
  sha256 "9c55eea568d869596ff12edf5c23b70596a521060e5ee83293a78e776272e06c"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19cd589985bca1903486b76c3da6932138ef17dcd33d437a354a31c4c1eac0de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16ee0c4ebf297c57ffd79be37074bff5147a09edf4dfd41695122557d1d24abf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c20c0c45c7e0191b4e4af19e0499f1d3e7fc7fea8c63ab39dc683482a4f8c3a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4715fd7752f5f26ee2eff1957208cc45c76909e7021dc8ca1e835729b68e1b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41bd4d926e799351f1cebf2f4ee7097f5b5b14deecceff9ad742d99991923066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68f6c5b0cefda77aa48d5905014e774605e9a25e811a5363f24240373099b00"
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