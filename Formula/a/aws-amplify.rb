require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.7.1.tgz"
  sha256 "2fcd56f8aca0eb82a403d2e3a017f588225b5b64164358ee8382717e21ad2f5a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0322e43bb4c8a015eb7144133d351c7c680d04ecee60441c19218feb7bac7847"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0322e43bb4c8a015eb7144133d351c7c680d04ecee60441c19218feb7bac7847"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0322e43bb4c8a015eb7144133d351c7c680d04ecee60441c19218feb7bac7847"
    sha256 cellar: :any_skip_relocation, sonoma:         "1478ceca4c40ed25407a2e84f71ab9c4398fc73a1a77f1d94245091a1454591b"
    sha256 cellar: :any_skip_relocation, ventura:        "1478ceca4c40ed25407a2e84f71ab9c4398fc73a1a77f1d94245091a1454591b"
    sha256 cellar: :any_skip_relocation, monterey:       "1478ceca4c40ed25407a2e84f71ab9c4398fc73a1a77f1d94245091a1454591b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "318b63ea58ad82b151610202015d98e0ef95cc07f80cc7f6b7d17640812b454b"
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