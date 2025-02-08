class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.14.3.tgz"
  sha256 "f5d02c65af9b3b8f6921ff323921c087bc16822ad50c56fee4bed2dd1d0bb04d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d84c688924ca056034840679e30fa6f58d461b217a1331392ae6c7c8d1ff531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d84c688924ca056034840679e30fa6f58d461b217a1331392ae6c7c8d1ff531"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d84c688924ca056034840679e30fa6f58d461b217a1331392ae6c7c8d1ff531"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aa2d4ef42aace4d858ad481406bfbee09caccfc40d0e39f00c0700e78c46e50"
    sha256 cellar: :any_skip_relocation, ventura:       "1aa2d4ef42aace4d858ad481406bfbee09caccfc40d0e39f00c0700e78c46e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4dd7134dcabfd799eb09e39548c0cb367d44d03450d4d69c3239b44f2106b11"
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