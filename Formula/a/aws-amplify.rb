class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.14.4.tgz"
  sha256 "cae976de3b5e838070c4bdfd453371c821a2c290bc886976d8ecc3d7bf0ebdbf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47dd673e4ede0e8a37ffeebb3e9f59d7e8cc9fd9a7c6bb9bc399380c78d1d136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47dd673e4ede0e8a37ffeebb3e9f59d7e8cc9fd9a7c6bb9bc399380c78d1d136"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47dd673e4ede0e8a37ffeebb3e9f59d7e8cc9fd9a7c6bb9bc399380c78d1d136"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b21976288eec6c7dafab34187e716474d60773b005fcf53e79f88e5b7863f30"
    sha256 cellar: :any_skip_relocation, ventura:       "1b21976288eec6c7dafab34187e716474d60773b005fcf53e79f88e5b7863f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "036573c652e1fd75fb534f6f98dc9bce2aa8ee1e196c77fe85a929b81026fe48"
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