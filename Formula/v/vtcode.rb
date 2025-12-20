class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.50.7.crate"
  sha256 "ea1c077c168e9f0f473db6cbe5591aa18e269aeb3a061be642cf22d7500b3ce6"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7448390126690ff1caa9b3866a9dc8252f459cf75bc63a7a42274dcfe0afb274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "577ce55956647a86446a40cc55546f2811050e4880e392cc204b1a0e9fe8323d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d51c4cc9f354136d79a9d6555418f0a50ad743dd4349cd962ada0cc8ae0dd024"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2028a7cd05ba9298e5568c520ee02a19cb1493020720795f5b1690865a97acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a36d84d6b5220d834ed625c6d64d6a1e45284c42afbe5e336a5a656b7beba3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f3e22c9d6c6dc5cec53c5000f7bec8bc2102ab3f34fa6fb7d527d909c8a3e83"
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