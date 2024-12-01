class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.13.1.tgz"
  sha256 "2b32f0a6a39995b8ef2e1cf0937b4efef5fefe9c3d25a3a300bdbad301f9de63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "317c3ee851873728ef57fd4dcd7add1bb53bd54a5e8b0fcf9b680cdb244a3edd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "317c3ee851873728ef57fd4dcd7add1bb53bd54a5e8b0fcf9b680cdb244a3edd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "317c3ee851873728ef57fd4dcd7add1bb53bd54a5e8b0fcf9b680cdb244a3edd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1564f00eecef188eca8ce458bfd35e3e9684017d7040d9c0e9b40d7739e4ed15"
    sha256 cellar: :any_skip_relocation, ventura:       "1564f00eecef188eca8ce458bfd35e3e9684017d7040d9c0e9b40d7739e4ed15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff27297bcc5b3e627031fa2d634da3b73b609ac184379cd01854550f8782ba9"
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