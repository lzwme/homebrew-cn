class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.53.2.crate"
  sha256 "87d5d27e9fd1f85bb3592370b63851081eb038d878abd3d07c2d3e32b8e9057c"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eba718e059b6b3f1fee56007b9440f7f7f1516fc5e391a37432848e5af8a68e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c502c2b3c453d6c4ab4778c364e7265ca8cf1d46fca1783d1df51893dbcd6fe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4957a8aff97ded3d9833d91c185f45527e96197db518d41d7811dadc61f827f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eea912e356d3d66ccdeec7525e461128fdb605138b35ce9199602750e7f0366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c2cb494597ef786bce403c25eaf14b1a8f1b4c26d47553e8219ae17617ad089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24672a366ea14ca2bba62572d763306124fa79f4e4a8c41b9075dc83f7b87b66"
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