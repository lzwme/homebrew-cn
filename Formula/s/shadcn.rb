class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.20.1.tgz"
  sha256 "ee12668d07dbfa45a409f004b1b6f47dc313bab50b3710d9f3f0136397a52cf6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3e6a891e092527c4de4f58136f2948da5205cbec55d3dcd99eedd35b332b10b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3e6a891e092527c4de4f58136f2948da5205cbec55d3dcd99eedd35b332b10b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3e6a891e092527c4de4f58136f2948da5205cbec55d3dcd99eedd35b332b10b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90860c46ac8b88c7289314a3d48508e754209d5823ba8e6b85bf38fe97226965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90860c46ac8b88c7289314a3d48508e754209d5823ba8e6b85bf38fe97226965"
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