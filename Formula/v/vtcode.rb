class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.45.4.crate"
  sha256 "8b28b54de855e5f8b2f47c1d2653b623840b3025cf038202315de7208213284d"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8ec7ad796189f6fdde5cbcf9e4825ba8f67b1f50ad594a48cde5d4e640a82b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eadd6314a3dfaa7c77bf5b9b06a39933d22da5c080b721328df5fc2438cfd084"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b8ecaec4a6634d3f7b438c05737fa7196435622819d837ea84e08d868e3c15e"
    sha256 cellar: :any_skip_relocation, sonoma:        "358697003e80753d8378cd80b3c5ffd799ced864d307d102a496d1f1a695d2e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db29ea9d707f969d3121589df1e3a3e775907d60d74011fd949208875eb2786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02007086928fd579c13fd2e9313d7f4a8505e4d0a9820bc5de2bf370577422e4"
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