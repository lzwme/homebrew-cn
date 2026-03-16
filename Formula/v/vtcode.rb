class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.89.0.crate"
  sha256 "1e5e08b8cb2425dc37839b356b22f1e71a91a9428dc8687d8dc2c6eedcb761ba"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bf9bb6777e88b90fc086fdec09d086c2b7691604520b71d2bfc10b75b94ece8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef837b4ff94cb548064b923e0634060788e69ede3122eb4c9380f52e3ed10921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9cf56213a53fa2b17b53008be749dab413c912abe5e49dd11d8dd62e10a74f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "41b5e4396ec91ed6a1fb7694a624af60c8397172fd04888f47385c66a60fb0c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59117dd3aa616a35d65a043570943174ba484795ba89eeb92572c17dd4c0dddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cd35125d2077c9015245060827388b850b9f887ca874674feddfe96c2318422"
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