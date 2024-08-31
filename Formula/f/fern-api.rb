class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.40.2.tgz"
  sha256 "4910c01127a5898f19a2f0e0e8d05ce2c8cc05c68049ed28764552f6464184d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d96991064c50618246717ce299ab74f94a377d0c3de6633ccd20a5b6431bd94"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end