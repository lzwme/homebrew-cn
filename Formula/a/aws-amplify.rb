class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.2.1.tgz"
  sha256 "13fb0214d9ab78f828db3e31a76669ee6065fd11e13a5b484581ed740f0680b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7521d63e48f1ffc541fd27ddae2e1ceedb60b034b1e8dc1e3a96fa79b1473541"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7521d63e48f1ffc541fd27ddae2e1ceedb60b034b1e8dc1e3a96fa79b1473541"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7521d63e48f1ffc541fd27ddae2e1ceedb60b034b1e8dc1e3a96fa79b1473541"
    sha256 cellar: :any_skip_relocation, sonoma:        "b87f7eb9f34563ba12edf5f5f316b27a7a21c956fb68c7fbd92f5a155d077ec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7521d63e48f1ffc541fd27ddae2e1ceedb60b034b1e8dc1e3a96fa79b1473541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b87f7eb9f34563ba12edf5f5f316b27a7a21c956fb68c7fbd92f5a155d077ec6"
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