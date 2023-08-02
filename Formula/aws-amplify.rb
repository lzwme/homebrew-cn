require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.2.3.tgz"
  sha256 "b7bb92591d73420ea28b6696336d3977438e766de5de53bc1303a38313b82cfb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7a57a78e56f97e5ea40e4e424e65d72ec9c10948cb290f44ce283a681461c0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7a57a78e56f97e5ea40e4e424e65d72ec9c10948cb290f44ce283a681461c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7a57a78e56f97e5ea40e4e424e65d72ec9c10948cb290f44ce283a681461c0b"
    sha256 cellar: :any_skip_relocation, ventura:        "4b586d3a18e27237f08ff98a9ef836cea1bb30f5e2d7c6bddd165a79b69b6cbe"
    sha256 cellar: :any_skip_relocation, monterey:       "2347cd9460a2818572fb4e05d760141628308b81676d68b65f0443c9b32e41df"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b586d3a18e27237f08ff98a9ef836cea1bb30f5e2d7c6bddd165a79b69b6cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2965b57363602a4fdae28e7e76a660020db2946c4818d983164fd1406a67686"
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