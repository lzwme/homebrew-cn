class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.2.0.tgz"
  sha256 "31974e9f911199cd89227c3334bbe0fa8bba86b820b515c4ac628dc4b2845df1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2c7910b4c3216ffe487ecddbf0319f8c077ac170e9247f5a0c26e34745b9fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c7910b4c3216ffe487ecddbf0319f8c077ac170e9247f5a0c26e34745b9fbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2c7910b4c3216ffe487ecddbf0319f8c077ac170e9247f5a0c26e34745b9fbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "d58795b319b4c7d3f614273eaf7c2f2935d01d89d311927e90765283066cf255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2c7910b4c3216ffe487ecddbf0319f8c077ac170e9247f5a0c26e34745b9fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d58795b319b4c7d3f614273eaf7c2f2935d01d89d311927e90765283066cf255"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    unless Hardware::CPU.intel?
      rm_r "#{libexec}/lib/node_modules/@aws-amplify/cli-internal/node_modules" \
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