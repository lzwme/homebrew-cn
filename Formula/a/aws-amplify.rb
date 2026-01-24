class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify/"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-14.2.4.tgz"
  sha256 "2fd867f654d78518c9a312e473961abd8c6535d3d7d853a7f132d81243f6f220"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81d4495d854aec4f2d03271cf38c6faba7e0de86b7f4e9db8dcc533ba4f39a64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1346872d52e6a127705007d551d28d144faf13cf8cd4c91f77782314232519dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1346872d52e6a127705007d551d28d144faf13cf8cd4c91f77782314232519dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2d8b41d8988837a748249fed27a62d3c45fd358521dbb513c7601d85344e83a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d365d1395f0eb096abd7c1f0b069e59e38f33297230c23c26f5bfc2d6ddddfd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "904512f2bea3bfd9b8b98545efc2fef36d74c53682d085cca1caea3df5708366"
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
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    require "open3"

    Open3.popen3(bin/"amplify", "status", "2>&1") do |_, stdout, _|
      assert_match "No Amplify backend project files detected within this folder.", stdout.read
    end

    assert_match version.to_s, shell_output("#{bin}/amplify version")
  end
end