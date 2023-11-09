require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.8.2.tgz"
  sha256 "a34f8c57b31bf797adaf1ce92ea1f25ddc02d129d4c6a8fa39a33d21d9807d2b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06b95bcc5b6a73d00b5315bbe29ade01ca96583c2461122d7eee3e7799aacdc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06b95bcc5b6a73d00b5315bbe29ade01ca96583c2461122d7eee3e7799aacdc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06b95bcc5b6a73d00b5315bbe29ade01ca96583c2461122d7eee3e7799aacdc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b44482e9dd8b69df052fad8c3e44771fa82ac6f90fa1313fb60e4d5c4e8c3c4"
    sha256 cellar: :any_skip_relocation, ventura:        "2b44482e9dd8b69df052fad8c3e44771fa82ac6f90fa1313fb60e4d5c4e8c3c4"
    sha256 cellar: :any_skip_relocation, monterey:       "2b44482e9dd8b69df052fad8c3e44771fa82ac6f90fa1313fb60e4d5c4e8c3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "accd7b3a007b6f680d75f080afd287524263b1b1250bc5d548b11502920ff045"
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