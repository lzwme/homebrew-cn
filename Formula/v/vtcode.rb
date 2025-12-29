class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.54.3.crate"
  sha256 "6fd5d0280bd311e6f3cde52c1c3e632cdd94d6f3ce3eea9c176310adf24b81cd"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0c869f7d4d121981c063568fa8445297301522d9e9ef125ced6bc989768f402"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2431ec9fdf7649fb293b9dd0b83ccf86b9e4fdbfc894de37ca5c49e55e6266fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7911359d1e6f4249870cbf57336e2902131f1c3614208abd720180d735009663"
    sha256 cellar: :any_skip_relocation, sonoma:        "45dd56a3b9ea8b9c725fbc402be42a13359cb28b29548d920b9e6bd32f2f0fde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c32cdbb353252c197766f6b65ff488d1faab7d7cbc0c2a10970275fae4f1105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abd8799961788786a581e4df44efd8b4821e358deab533c93cc0191d915c2264"
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