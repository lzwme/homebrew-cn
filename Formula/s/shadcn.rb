class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.12.0.tgz"
  sha256 "8ae91a576a5ce626ccaa771329afa7691c9357250330647786f94bc3c22ba518"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f7e94eca45d8e136d2be1e7b80401623415f050d21262dca4946d9b1623532c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f7e94eca45d8e136d2be1e7b80401623415f050d21262dca4946d9b1623532c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f7e94eca45d8e136d2be1e7b80401623415f050d21262dca4946d9b1623532c"
    sha256 cellar: :any_skip_relocation, sonoma:        "397ff3cd9b3ac4b46de7bf79ac208adba74b61dc2e941463db155f16430f3610"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4874428fed075f2c5bd8f8c6776380b32903fe7ed1d20f1200af1c8bc8b8a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4874428fed075f2c5bd8f8c6776380b32903fe7ed1d20f1200af1c8bc8b8a31"
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