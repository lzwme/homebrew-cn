require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.9.0.tgz"
  sha256 "8d5cc278008700ca26bfad428653c665ec6787a2f4551a8bf1e178116e616024"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7d04015312e4ac3f4e7340a25efd99ad33db4d6562d95a5f5141fb1b1d8ede3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7d04015312e4ac3f4e7340a25efd99ad33db4d6562d95a5f5141fb1b1d8ede3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7d04015312e4ac3f4e7340a25efd99ad33db4d6562d95a5f5141fb1b1d8ede3"
    sha256 cellar: :any_skip_relocation, sonoma:         "078ef6a69aeccb4e87b6e90131308446aa0bb83a55d9e51ddfa258cf9aa8f7a9"
    sha256 cellar: :any_skip_relocation, ventura:        "078ef6a69aeccb4e87b6e90131308446aa0bb83a55d9e51ddfa258cf9aa8f7a9"
    sha256 cellar: :any_skip_relocation, monterey:       "078ef6a69aeccb4e87b6e90131308446aa0bb83a55d9e51ddfa258cf9aa8f7a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c68f2662e2c8798de364742bc11e0270a7660ed76ed800dc1226573db238c7b"
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