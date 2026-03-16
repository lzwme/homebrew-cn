class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.0.8.tgz"
  sha256 "f200e984256f15c4367babf1d26feb2f5aa373822f48cf1654c680533389c0aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68ec910d353807553f8a275b8beea2294db32622da70f8c7885540516962dba5"
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