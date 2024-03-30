require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.10.3.tgz"
  sha256 "9f1fc4b2b006435b25b1ea9f309746571802bd14b288cf1dfdf64fd9d50f47df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebb0a165954c094a49de8e86a766b1701f621db6756ab1b921fb5a23310a7294"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebb0a165954c094a49de8e86a766b1701f621db6756ab1b921fb5a23310a7294"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebb0a165954c094a49de8e86a766b1701f621db6756ab1b921fb5a23310a7294"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebdd4ed29ae7918896ddd0ce033afacbf9574b0a1f4803e05220ef2bbe1bdd2a"
    sha256 cellar: :any_skip_relocation, ventura:        "ebdd4ed29ae7918896ddd0ce033afacbf9574b0a1f4803e05220ef2bbe1bdd2a"
    sha256 cellar: :any_skip_relocation, monterey:       "ebdd4ed29ae7918896ddd0ce033afacbf9574b0a1f4803e05220ef2bbe1bdd2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0878a345a394311570d999a96ee4a0a04f8c1aae82415d2b1c89aee99f0c34ef"
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
  end

  test do
    require "open3"

    Open3.popen3(bin/"amplify", "status", "2>&1") do |_, stdout, _|
      assert_match "No Amplify backend project files detected within this folder.", stdout.read
    end

    assert_match version.to_s, shell_output("#{bin}/amplify version")
  end
end