class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1297.2.tgz"
  sha256 "f90015b7a6bd05400f1e0b5942b862e2c647641110a19cda631284320e77974a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "692747b95b6b9881b5e60f642ebc966fc836bf160dee2597da19f136847655a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "692747b95b6b9881b5e60f642ebc966fc836bf160dee2597da19f136847655a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "692747b95b6b9881b5e60f642ebc966fc836bf160dee2597da19f136847655a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee3a14545c552e321b539f523fd01f0b58113ee6fa5f1eb595720a1f7cfe7209"
    sha256 cellar: :any_skip_relocation, ventura:       "ee3a14545c552e321b539f523fd01f0b58113ee6fa5f1eb595720a1f7cfe7209"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87dca87a4109802f4838fbf07273598b3f88663ac251856f097efa6276191d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc9958bac9e79d3b7ebdb3d917e0929f8868ae2877b5646b6dce3a0e65a59102"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove x86-64 ELF binaries on incompatible platforms
    # TODO: Check if these should be built from source
    rm(libexec.glob("lib/node_modules/snyk/dist/cli/*.node")) if !OS.linux? || !Hardware::CPU.intel?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end