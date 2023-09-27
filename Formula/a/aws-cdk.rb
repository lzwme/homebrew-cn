require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.98.0.tgz"
  sha256 "6f6c62e7dd234870da1cc581fc6d72253839b6fc9c87eeb0f9d239ffcfb0b0d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c923a01e6512a1fcb0058c87384a17c6296ac1a03338bf0f03ea5665333f7485"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c923a01e6512a1fcb0058c87384a17c6296ac1a03338bf0f03ea5665333f7485"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c923a01e6512a1fcb0058c87384a17c6296ac1a03338bf0f03ea5665333f7485"
    sha256 cellar: :any_skip_relocation, sonoma:         "301e10774a15e58487b6512dc37ae15c7fdb49378f6d0155c5729159eeb39ee9"
    sha256 cellar: :any_skip_relocation, ventura:        "301e10774a15e58487b6512dc37ae15c7fdb49378f6d0155c5729159eeb39ee9"
    sha256 cellar: :any_skip_relocation, monterey:       "301e10774a15e58487b6512dc37ae15c7fdb49378f6d0155c5729159eeb39ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f5f3ac60a7da5df89f9778ed1016556de70f4ad5b1a9dca5f9cf244ba27c1b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end