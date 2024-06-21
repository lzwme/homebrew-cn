require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.12.3.tgz"
  sha256 "8f9772238a84d4146e01d3135a24274b6ee87d9b7f51249b4f259533ffb161a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20f82868e2f087ae1a0c19e8f0fb5a470fd04cfe1d993b10d42facd045482030"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20f82868e2f087ae1a0c19e8f0fb5a470fd04cfe1d993b10d42facd045482030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f82868e2f087ae1a0c19e8f0fb5a470fd04cfe1d993b10d42facd045482030"
    sha256 cellar: :any_skip_relocation, sonoma:         "00fd90bcbdb36ff65237b1811880c46ee517ce86b76a8f2191dfcb352c7acdf8"
    sha256 cellar: :any_skip_relocation, ventura:        "00fd90bcbdb36ff65237b1811880c46ee517ce86b76a8f2191dfcb352c7acdf8"
    sha256 cellar: :any_skip_relocation, monterey:       "00fd90bcbdb36ff65237b1811880c46ee517ce86b76a8f2191dfcb352c7acdf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d44ed4da65c4acfe26a538c2e45f045eb0a7a1c2c73a88e4f3adaa39df45f6c4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    unless Hardware::CPU.intel?
      rm_rf "#{libexec}/lib/node_modules/@aws-amplify/cli-internal/node_modules" \
            "/@aws-amplify/amplify-frontend-ios/resources/amplify-xcode"
    end

    # Remove non-native libsqlite4java files
    os = OS.kernel_name.downcase
    if Hardware::CPU.intel?
      arch = if OS.mac?
        "x86_64"
      else
        "amd64"
      end
    elsif OS.mac? # apple silicon
      arch = "aarch64"
    end
    node_modules = libexec/"lib/node_modules/@aws-amplify/cli-internal/node_modules"
    (node_modules/"amplify-dynamodb-simulator/emulator/DynamoDBLocal_lib").glob("libsqlite4java-*").each do |f|
      rm f if f.basename.to_s != "libsqlite4java-#{os}-#{arch}"
    end
  end

  test do
    require "open3"

    Open3.popen3(bin/"amplify", "status", "2>&1") do |_, stdout, _|
      assert_match "No Amplify backend project files detected within this folder.", stdout.read
    end

    assert_match version.to_s, shell_output("#{bin}/amplify version")
  end
end