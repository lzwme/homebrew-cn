class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.49.1.crate"
  sha256 "4e1bd2365b8fb60871b10cf4df72a6de26c9ef276d6212601d5ad550189cdc1e"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1214fd967bf87c51ae9f50dcd4d7f38eb66660f907264477bce870938739434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a4d4c71025a0ca40448ef442e43a865c17024314bcfd56e441cef3d0a2891be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4caacd95f8c2a1db60eef64dd391060bef91cc6cdf60fe21ec4c3b9a1b54654"
    sha256 cellar: :any_skip_relocation, sonoma:        "80f9a60576e4a23d7d58b9ad0aa1e49e55c318c3862a10aafba0b8992dd6b30c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bbc0a67b7bdec01f2949175b5db47653bb1f5d1f6f48fe2cc225bb866a5ae6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95a9251939f4fd8d7d8a0fa3a7fdfbdf09f4fa52eca87eba14a9615923fe03a2"
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