class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.43.3.crate"
  sha256 "618e88c3910ff4a566dc56d2e7f3a9f99e966a375d7ab3d58b37b0af0b35daec"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84e9c0338e5c5fe1e56c68279ee38734a06356146a7121aa5d2005137c4c9c6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6fda930eeacf51d60cc274364fb1fc4381a5d8ce684fd050d19ffb48e461866"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23726e0035a0d90e6cab157fd9626b3f306c43a9636d5cbe35987bcaaf445530"
    sha256 cellar: :any_skip_relocation, sonoma:        "74b19014cde6276b9168a56dd8fc4a4d0a93ccdc9193ca768e9a6cd70b7f11bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd9cd7930d08fd504ef9172ecec5490acbfb255a7642c3a7ec51a6d43de7cb15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f76de44e88e3ad7a2a10a56c4ef18ddbdedf7a7062d876b4020fa56ddcf07a"
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