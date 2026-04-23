class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.4.0.tgz"
  sha256 "9c68ffa6652820ba11c72342bc3765e20bbe6fc5c1588acf0cc7d3255d1ce33b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dbcf1633d5db983de4d1672b85c8faf40cc2ea1935110089e9d88db75b163c72"
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