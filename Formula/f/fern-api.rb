class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.75.5.tgz"
  sha256 "832b9d2f3be920641e478f270cd15d02307db052b8728030b1a379702d554f5f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9cebafafa2d9a28cd4ce42b7f26bd11775d524b854d2161e57bd6064c3e730f"
    sha256 cellar: :any,                 arm64_sequoia: "e9cebafafa2d9a28cd4ce42b7f26bd11775d524b854d2161e57bd6064c3e730f"
    sha256 cellar: :any,                 arm64_sonoma:  "e9cebafafa2d9a28cd4ce42b7f26bd11775d524b854d2161e57bd6064c3e730f"
    sha256 cellar: :any,                 sonoma:        "1eda6ba27918ce49b307b753431965494a44fa87884316b02e8be67c53c54260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "614c0f6b6f4f89c8bd408a4c92f9fbeebe07fcbb034db7d9c8106cac9e17ce0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dea29817a7acd31a085288ce5501f5096ac71e73bca32027d9a5502b9921313a"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end