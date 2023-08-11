require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.2.4.tgz"
  sha256 "714110832c5c10f668d24c87b0cfb3da2d58f13d5a916fa235a4fc57372d053d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08fb574367df752bd4915b9825cac70bbd65b0f01562083da5ec3c6ff85d961e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08fb574367df752bd4915b9825cac70bbd65b0f01562083da5ec3c6ff85d961e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08fb574367df752bd4915b9825cac70bbd65b0f01562083da5ec3c6ff85d961e"
    sha256 cellar: :any_skip_relocation, ventura:        "74ac427c2bbd03b5ef24cab8dc30eb8c39a65cd834f034e852e2ec2a7078b2cb"
    sha256 cellar: :any_skip_relocation, monterey:       "74ac427c2bbd03b5ef24cab8dc30eb8c39a65cd834f034e852e2ec2a7078b2cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "74ac427c2bbd03b5ef24cab8dc30eb8c39a65cd834f034e852e2ec2a7078b2cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec1a629cc82984cfbe66795c02fa92bd783d4a78bed78d347d17763a1110137d"
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

    # Replace universal binaries with native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    require "open3"

    Open3.popen3(bin/"amplify", "status", "2>&1") do |_, stdout, _|
      assert_match "No Amplify backend project files detected within this folder.", stdout.read
    end

    assert_match version.to_s, shell_output("#{bin}/amplify version")
  end
end