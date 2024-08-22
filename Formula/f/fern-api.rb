class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.15.tgz"
  sha256 "55e80245c07f452794521e8340f1c6bcd8c8bb271009547fb497fb98b733ff96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b5aea5eae18708293eb7acd852d96e421535ad2468833d2fac4f95b92add66c"
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