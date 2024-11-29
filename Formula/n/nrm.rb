class Nrm < Formula
  desc "NPM registry manager, fast switch between different registries"
  homepage "https:github.comPananrm"
  url "https:registry.npmjs.orgnrm-nrm-1.4.0.tgz"
  sha256 "b741a633d8d2d5e7ea7f8dd1d9709999926c2c8f5e80a94b8225ccb1a446a4e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59b4f5f3dc63191e35344d61dec81d4bf134f4f338a48efae5979d6a2215e8fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59b4f5f3dc63191e35344d61dec81d4bf134f4f338a48efae5979d6a2215e8fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59b4f5f3dc63191e35344d61dec81d4bf134f4f338a48efae5979d6a2215e8fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "edb0d1ea6786ae796bbd9e7b3c4e76f6209e64627f9a9c5ded2ff8ea5279dce0"
    sha256 cellar: :any_skip_relocation, ventura:       "edb0d1ea6786ae796bbd9e7b3c4e76f6209e64627f9a9c5ded2ff8ea5279dce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b4f5f3dc63191e35344d61dec81d4bf134f4f338a48efae5979d6a2215e8fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "SUCCESS", shell_output("#{bin}nrm add test http:localhost")
    assert_match "test --------- http:localhost", shell_output("#{bin}nrm ls")
    assert_match "SUCCESS", shell_output("#{bin}nrm del test")
  end
end