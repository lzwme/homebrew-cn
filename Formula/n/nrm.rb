class Nrm < Formula
  desc "NPM registry manager, fast switch between different registries"
  homepage "https:github.comPananrm"
  url "https:registry.npmjs.orgnrm-nrm-2.0.0.tgz"
  sha256 "8c295be621adbf110135dd6203d509a5f04d35285490cacf7c50bb697bf46fca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7cadb13c5f1b01d50e56dd192b97bfae3a0a5d1cfd172c6f5685d22eede246b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7cadb13c5f1b01d50e56dd192b97bfae3a0a5d1cfd172c6f5685d22eede246b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7cadb13c5f1b01d50e56dd192b97bfae3a0a5d1cfd172c6f5685d22eede246b"
    sha256 cellar: :any_skip_relocation, sonoma:        "371aa9efdc19c35887257b1c01dce0fd0d0a057a37654d4a2e8b6719f5c1adf0"
    sha256 cellar: :any_skip_relocation, ventura:       "371aa9efdc19c35887257b1c01dce0fd0d0a057a37654d4a2e8b6719f5c1adf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7cadb13c5f1b01d50e56dd192b97bfae3a0a5d1cfd172c6f5685d22eede246b"
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