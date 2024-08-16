class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.5.tgz"
  sha256 "21cdec5044b9aa79391c66ab6b3a7e3ca35226bbfe56417646561786b3f7d55a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e5f05705abdedb76565a6eb3474c4ca29ef16b89cca3adb8898e5d12f6895b8"
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