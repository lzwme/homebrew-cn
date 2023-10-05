require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.5.2.tgz"
  sha256 "530489f5349a71c30d950d65148acda8876930102e118a44834da200bf23c7d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5dc9bb7f732e018bac019ee9fe3a78fcdd352c9221acf4c8ee228aade00d6a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5dc9bb7f732e018bac019ee9fe3a78fcdd352c9221acf4c8ee228aade00d6a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5dc9bb7f732e018bac019ee9fe3a78fcdd352c9221acf4c8ee228aade00d6a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "23e29eca4b5a09670a7d1f2a67de009816900878fcc04244db51677729765530"
    sha256 cellar: :any_skip_relocation, ventura:        "62f64e16922ecfc5382ddf1abda40a0db92477079537aff59cddec417c9aaaf1"
    sha256 cellar: :any_skip_relocation, monterey:       "62f64e16922ecfc5382ddf1abda40a0db92477079537aff59cddec417c9aaaf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d4f2300e2e3f6599f46821f7b30c920a5651c10ef6ed0fbde5a17c3871e1a2"
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