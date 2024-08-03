require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.12.5.tgz"
  sha256 "b19d161067d1f8aeb1abaff5115bdf3d51e4b994b6defdfc6015490ee6fbf9b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e4245576b6ae69c8259474494d2366b549185d57f4370ae0790f223eb03121b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e4245576b6ae69c8259474494d2366b549185d57f4370ae0790f223eb03121b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e4245576b6ae69c8259474494d2366b549185d57f4370ae0790f223eb03121b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f96100371f5f40ac35105545bde3cbd07c6d20d11e0c6c275e0bbc2d3e11e247"
    sha256 cellar: :any_skip_relocation, ventura:        "f96100371f5f40ac35105545bde3cbd07c6d20d11e0c6c275e0bbc2d3e11e247"
    sha256 cellar: :any_skip_relocation, monterey:       "f96100371f5f40ac35105545bde3cbd07c6d20d11e0c6c275e0bbc2d3e11e247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4728ffef20091bcc1def83a065ef42cf390103c5036a046dd55bc684d096d04f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

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