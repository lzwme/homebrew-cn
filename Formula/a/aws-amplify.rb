class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.1.1.tgz"
  sha256 "206c59e58edfcbcba646889c5d1ef5d50b8e81387d9fd1829731f6f1b9879ca3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "407d198ea88cf0c0a702341092da93d254df98fe59a3314be7e20ee9f7774e4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "407d198ea88cf0c0a702341092da93d254df98fe59a3314be7e20ee9f7774e4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "407d198ea88cf0c0a702341092da93d254df98fe59a3314be7e20ee9f7774e4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c22d3dcd02e950760dc3306b37380b191c169dc5c408b9f38d82f92fb54214f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "407d198ea88cf0c0a702341092da93d254df98fe59a3314be7e20ee9f7774e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c22d3dcd02e950760dc3306b37380b191c169dc5c408b9f38d82f92fb54214f"
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