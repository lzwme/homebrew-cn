class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.43.tgz"
  sha256 "ea5f4403268ef37fa30c29a2849d31ba01b0230fd184fafdf6e1741ee8d7b2fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "64e7ff8684e0c4cbbc3aaa832055affe01c931b0d74a89f6e06aa5fac8315715"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnhf --version")

    output = shell_output("#{bin}/gnhf --current-branch 2>&1", 1)
    assert_match "gnhf: This command must be run inside a Git repository", output
  end
end