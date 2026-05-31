class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.8.3.tgz"
  sha256 "705646f2879f4af23d798b02182016d4606df83941efc85614d1585420b690d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1dbdef52a23dec05d0a6160bff1f0aeeef904e7edf7e00cdb475add12acd8fb"
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