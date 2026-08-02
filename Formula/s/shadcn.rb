class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.16.1.tgz"
  sha256 "cb6dbf510fd78d231f61893f9c8c7e6f06d6f6e73434640011abd7911d3186d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ecf9b62c898740fca55c59819e8459d276c76dbe3945d651048c7b2ae323aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ecf9b62c898740fca55c59819e8459d276c76dbe3945d651048c7b2ae323aa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ecf9b62c898740fca55c59819e8459d276c76dbe3945d651048c7b2ae323aa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bd34542e724aacd029530c4a2850ad2cc9dc306549e8461da6980bb1f76a0cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51f6b82dbe3527942c8b7e40888511faccc4473af044e20ac30ccfb245f531bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f6b82dbe3527942c8b7e40888511faccc4473af044e20ac30ccfb245f531bd"
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