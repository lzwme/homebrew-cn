class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.15.tgz"
  sha256 "87bfc56256c7d8880be2df7e1f837cfe08e99b9716ea70b4f31fbe387552d3f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "abfe42d3b5f675579064c2512b3612cd474b62e4f0acc3dc62691e69cd7d8d39"
    sha256 cellar: :any,                 arm64_sequoia: "b5185fee35bdda1e74526f6b3a960b2b9d9933fb792ec83fbdc78f876b325353"
    sha256 cellar: :any,                 arm64_sonoma:  "b5185fee35bdda1e74526f6b3a960b2b9d9933fb792ec83fbdc78f876b325353"
    sha256 cellar: :any,                 sonoma:        "eeb6f3c699ac69d8055c2c02a1d41dd124a0b5a3b5719edd6c2ab7dc9623802c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bb4d4bbfa8aa360c75dc447871bb3f4d46b6b7e6d6e9cd7f710b31267a34669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ab05cf172d3fc93bf9a645a71766c5daed3f6df34fb501d0c7e7f8f0c118557"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end