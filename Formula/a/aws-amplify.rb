class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.1.0.tgz"
  sha256 "ecd4efc4f7b49fe6006ddb823eeee66d52c69c14be0805b3bada76fb8ec99bf1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "988088790a70285b5ec62313a6d0216bbea1331b2a7bdb3d8bfaa1236797d632"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988088790a70285b5ec62313a6d0216bbea1331b2a7bdb3d8bfaa1236797d632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "988088790a70285b5ec62313a6d0216bbea1331b2a7bdb3d8bfaa1236797d632"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7a1e872296a1692cf2c12afd978feb726ae348944e5454a3e33b75eb68e71c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "988088790a70285b5ec62313a6d0216bbea1331b2a7bdb3d8bfaa1236797d632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a1e872296a1692cf2c12afd978feb726ae348944e5454a3e33b75eb68e71c9"
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