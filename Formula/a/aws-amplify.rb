class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.12.5.tgz"
  sha256 "b19d161067d1f8aeb1abaff5115bdf3d51e4b994b6defdfc6015490ee6fbf9b9"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "364145b800db47837ffa42d14a00e09407875b9e9e882ec9b4f464e2dc2192eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "364145b800db47837ffa42d14a00e09407875b9e9e882ec9b4f464e2dc2192eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "364145b800db47837ffa42d14a00e09407875b9e9e882ec9b4f464e2dc2192eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "efaaf9a3c671a836b89b1985245d97188d70358b2510afdc4f45920324bc2f90"
    sha256 cellar: :any_skip_relocation, ventura:        "efaaf9a3c671a836b89b1985245d97188d70358b2510afdc4f45920324bc2f90"
    sha256 cellar: :any_skip_relocation, monterey:       "efaaf9a3c671a836b89b1985245d97188d70358b2510afdc4f45920324bc2f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09d4fadd372eddfb1d94943a673c0d1fb90e21f7c65d052322d5149fc05fb0b"
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