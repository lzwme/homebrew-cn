class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.49.7.crate"
  sha256 "017fcc799762a82fedd05b109132ced9deb8eac69a199d42f739919b98342427"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf07dc22e1842cb65fab32a20c22c9c7d3cee38e3c6bbd695af2b4c4175ac674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afb7c225c3acdb330e3606a09350c5bf9ab065bc6cb8d082a823ebbc020fe130"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e1d8865c2a1b949f31ca5599f499b129381f36c9dbec57236f7ad85782fe219"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c3b1b5134713c61636b076874f3eef92023b3283e12c4e02628f50b05971c97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4d282063abd27b19b3ee2e08aac3d512f7ba33fb89b6d7bd83ef4e77f0982bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8509acf3f85718dc33f716a29c4cf65da5525050ca76c70834fdca3536226c8d"
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