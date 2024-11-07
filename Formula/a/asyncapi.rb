class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.8.1.tgz"
  sha256 "76d196302645ec73334e731baf3f7ec2497b27f314f7a50d0f5cc08c28ae8a12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c369e127195a2661d8620c674ee4ddb4a491d3eed8a2ee5a3dafe045126f63b"
    sha256 cellar: :any,                 arm64_sonoma:  "4c369e127195a2661d8620c674ee4ddb4a491d3eed8a2ee5a3dafe045126f63b"
    sha256 cellar: :any,                 arm64_ventura: "4c369e127195a2661d8620c674ee4ddb4a491d3eed8a2ee5a3dafe045126f63b"
    sha256 cellar: :any,                 sonoma:        "d0c6ddaaa98d0a043230db753d3a221b3aa7a7338ac3781d7238cd93324a9a8b"
    sha256 cellar: :any,                 ventura:       "d0c6ddaaa98d0a043230db753d3a221b3aa7a7338ac3781d7238cd93324a9a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6f0ea68d9675bcd9087a496b6846b589aff46559c71876cc9150de19435a08"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end