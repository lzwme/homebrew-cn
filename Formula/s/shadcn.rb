class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.8.2.tgz"
  sha256 "6d00f33efcfc2ce51b12d70e81a446591dd4125c16523ff1072cce390ef09ecb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87832ac54b3e401c35cbe0f94f2cdb3102c371445e9337ece28fe4a057dd2955"
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