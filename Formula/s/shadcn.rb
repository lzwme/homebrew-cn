class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.8.0.tgz"
  sha256 "f32d4d4eb7ffe4f0d6242096045b63d9a088a922767612fb57f8b3c912e2bfef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea93d5cde092d3638d20cf44de9288c1df440f70609accd135f56eacf9ffc27a"
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