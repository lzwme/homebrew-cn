require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.2.5.tgz"
  sha256 "d77234b2040d9b2f0c6a7484f1aa1611f9ba6330ea9a3a20902b409f9a9e50ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93748f4b2fe97b6e2ca7bca0da2ca4ef0088a5d72e5897905291ed71b0fa4b91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93748f4b2fe97b6e2ca7bca0da2ca4ef0088a5d72e5897905291ed71b0fa4b91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93748f4b2fe97b6e2ca7bca0da2ca4ef0088a5d72e5897905291ed71b0fa4b91"
    sha256 cellar: :any_skip_relocation, ventura:        "bf0f77b0cf39a5559405ad268302e069c54dfae6e77f6c6ed7d7c73b10039fd6"
    sha256 cellar: :any_skip_relocation, monterey:       "bf0f77b0cf39a5559405ad268302e069c54dfae6e77f6c6ed7d7c73b10039fd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf0f77b0cf39a5559405ad268302e069c54dfae6e77f6c6ed7d7c73b10039fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a34ceb9c0edca693b1dc0c503abcf6d1a67eb5f3715584d58938764f8afb31"
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