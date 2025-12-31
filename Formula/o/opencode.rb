class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.218.tgz"
  sha256 "fa5f6668d8fe9921ef885a12d39916bc8c96ab96c9d044afb27abf38fbc70308"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "12ca16da78e7f3f09ae819ec3bb95457ada5e9eef930461afde27f0a5654154b"
    sha256                               arm64_sequoia: "12ca16da78e7f3f09ae819ec3bb95457ada5e9eef930461afde27f0a5654154b"
    sha256                               arm64_sonoma:  "12ca16da78e7f3f09ae819ec3bb95457ada5e9eef930461afde27f0a5654154b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1e861c61d5bfed3a45152ea2638246014c7e468e611f5dfa143f06233d0e32c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4684f69e655e45bcf3b8dfdf89f6b38ca9c14de257849a774d4b101b67d3509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26fd5758ff9a985509de65552559a8a914e93e0f850c5659536be75d75a302b6"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end