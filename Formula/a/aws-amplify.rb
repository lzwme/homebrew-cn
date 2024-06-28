require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.12.4.tgz"
  sha256 "15cffbaa789c69981262fec17e24ce2a0df56219d01ea56bd2ed48270f27fbcf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ee229a7753b997822968bbd7efe8f2967b9f3c045395e9fe09f452d4dbd9e92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ee229a7753b997822968bbd7efe8f2967b9f3c045395e9fe09f452d4dbd9e92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ee229a7753b997822968bbd7efe8f2967b9f3c045395e9fe09f452d4dbd9e92"
    sha256 cellar: :any_skip_relocation, sonoma:         "68882551cfc74fd27349b14224f417ee1b4d592fda76bf4ddbfad27dcd216d05"
    sha256 cellar: :any_skip_relocation, ventura:        "68882551cfc74fd27349b14224f417ee1b4d592fda76bf4ddbfad27dcd216d05"
    sha256 cellar: :any_skip_relocation, monterey:       "68882551cfc74fd27349b14224f417ee1b4d592fda76bf4ddbfad27dcd216d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e229b175b0733b88e3dc526336e08b24b1d98ccd9b0d3db859be3840857bab47"
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