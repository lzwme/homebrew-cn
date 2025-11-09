class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.43.1.crate"
  sha256 "6734e655d35bb27d5bbe0d74116a5d225d73b30790fef7bff03a0c0fa4335514"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a3edf6612e09d12ee5a9475d4f54897676c685426bd3bbcd2a38a2e4dab38ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6193572f98adf8b33a0927de53fb44664acc3668e673954e39616940d89fdb17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8632b05e85b6915daf55bd1103a1651f338c85e352372dec797ee1584b527c49"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca62cd2bf7ffaa9888f61ad22d917491874efaea9d59c18f271723ed766f4846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "418a5cbf6b1d0604c9f7cc191fcd612cbf022ae153543c9373d68e87a250da8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "681b97fe4f553229d442c8025f1e86cfecb1562cb550a3d32ffa88722a26f476"
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