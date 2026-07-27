class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.15.0.tgz"
  sha256 "14535edb51ecd93c9ca55b52fecda91989cc9955fd6b332562cfbbb0927b0556"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dd56ce7807fa8700e891e2c257d9adca227efaf90816ada2d012d831faef23f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dd56ce7807fa8700e891e2c257d9adca227efaf90816ada2d012d831faef23f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dd56ce7807fa8700e891e2c257d9adca227efaf90816ada2d012d831faef23f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c17151273d5b098acac2b46aca45b78b9698f7a7e66e619c65ed6584433d7c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcedd136fa31959da7688a7dc58fe741bd98365a1e66f23e13f849b67e856bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcedd136fa31959da7688a7dc58fe741bd98365a1e66f23e13f849b67e856bcd"
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