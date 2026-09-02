class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.19.1.tgz"
  sha256 "60325b219320521f15cb7a3b692b95a9060fd1a5aadfcd5878b82c4b8b07e697"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffc3bb4306ae27b552e71ccf6b7466e1246ec2bd4bf055f3e2627b43ac83ac6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffc3bb4306ae27b552e71ccf6b7466e1246ec2bd4bf055f3e2627b43ac83ac6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffc3bb4306ae27b552e71ccf6b7466e1246ec2bd4bf055f3e2627b43ac83ac6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8999fb84ac8053537ff877942befb2c14ab2b2dba4001b971c2aff6ad119a719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8999fb84ac8053537ff877942befb2c14ab2b2dba4001b971c2aff6ad119a719"
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