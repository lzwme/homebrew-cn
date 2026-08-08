class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.16.2.tgz"
  sha256 "d3342d9a1deb672bd83c16e4f4c12f8cfe83737a7c3ed73e5e105e0f6a3a9591"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cb21d50decc9ab07afd659a2e4a6332e211fc9d80354330645a09ee4ca61e12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cb21d50decc9ab07afd659a2e4a6332e211fc9d80354330645a09ee4ca61e12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cb21d50decc9ab07afd659a2e4a6332e211fc9d80354330645a09ee4ca61e12"
    sha256 cellar: :any_skip_relocation, sonoma:        "1df591191b8d5f37129bb3b72a48771570bdff7cd5c9bdd71d66c1379c6481a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3b69b635971e27569ecb7dd152bdb025079d419664d55e2bc522e7184724063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b69b635971e27569ecb7dd152bdb025079d419664d55e2bc522e7184724063"
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