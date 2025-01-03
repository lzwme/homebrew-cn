class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.14.0.tgz"
  sha256 "7e9a40e4327d78dce4780ad4cffa1fbe571ee35b6e7dfcb16874452fb1feaad6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f247b7c3a967bea5201d82a917be2c935af8ca3720634690f7073141de77914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f247b7c3a967bea5201d82a917be2c935af8ca3720634690f7073141de77914"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f247b7c3a967bea5201d82a917be2c935af8ca3720634690f7073141de77914"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ea406301b4bc6aeb7a23745f9a046cf0c059ec8f2acd9272f0f72e2acd33ee"
    sha256 cellar: :any_skip_relocation, ventura:       "d3ea406301b4bc6aeb7a23745f9a046cf0c059ec8f2acd9272f0f72e2acd33ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac61d6b75d47bc42f98e4e838d6882afaa3000a735ebf6731992753756e86f1"
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