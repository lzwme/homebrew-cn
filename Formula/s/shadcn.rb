class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.21.5.tgz"
  sha256 "588f42db012fdd0edee6ddf0c1d79e0b94013188960d6a09c9e0c0e416bd2bab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f77f35bffbfbe4e4e3a78ca2bb74266f36dd5930f3ed26d62da79dc1f62754d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f77f35bffbfbe4e4e3a78ca2bb74266f36dd5930f3ed26d62da79dc1f62754d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f77f35bffbfbe4e4e3a78ca2bb74266f36dd5930f3ed26d62da79dc1f62754d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "57c381505d040efc3982e4a8c3198f70d16fcac4345ad6d9e8e9635a1de83f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "57c381505d040efc3982e4a8c3198f70d16fcac4345ad6d9e8e9635a1de83f09"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end