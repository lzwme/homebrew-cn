class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.21.3.tgz"
  sha256 "0ac1ce7c51ce8968ca302eb69de57146f6481b712c085d4510105d99b52ddba3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c867b43ea5e9a898207bacada03c8c4f951489e7f9cf5a18d2ac59d3613b07cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c867b43ea5e9a898207bacada03c8c4f951489e7f9cf5a18d2ac59d3613b07cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c867b43ea5e9a898207bacada03c8c4f951489e7f9cf5a18d2ac59d3613b07cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8680539e644d417782d28a639a10f5fc2541aa20e1f942c1090b1267576fa4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8680539e644d417782d28a639a10f5fc2541aa20e1f942c1090b1267576fa4b4"
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