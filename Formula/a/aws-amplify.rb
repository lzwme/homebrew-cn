class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.1.2.tgz"
  sha256 "cc4d8ba3ddd5cbd61620ba6afb011a5e9913f0714a4d12d78ef46c89b24d867e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46d03dceefabac11da3bb674ce5139fbe5db6ae1fcbbe123d09727e9accbe9cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46d03dceefabac11da3bb674ce5139fbe5db6ae1fcbbe123d09727e9accbe9cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46d03dceefabac11da3bb674ce5139fbe5db6ae1fcbbe123d09727e9accbe9cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b61c8972eefcf7b2b82ce0730a93b553765e7602549f8c6a4c4942fda08a6cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46d03dceefabac11da3bb674ce5139fbe5db6ae1fcbbe123d09727e9accbe9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b61c8972eefcf7b2b82ce0730a93b553765e7602549f8c6a4c4942fda08a6cf1"
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