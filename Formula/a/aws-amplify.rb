require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.12.1.tgz"
  sha256 "14d783f45402a153d6ace78d3beaa477c0248b708b509d15fcdf21dc531e9acf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "276234f0ef157342ae853d1089edaba705e3149f1665e443025eca883229727f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d81403b5fc721988aa2ed026fd9a9865f099ac62418c5c62b17c279df46ea80a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae0f341dc36f43cbc10c46aefefe0f1b862ca47c5f62475def2d7b409757d33b"
    sha256 cellar: :any_skip_relocation, sonoma:         "aba208ba3e05585c7531296ce05322c06abcd258d7256b2db68c824d8d34202c"
    sha256 cellar: :any_skip_relocation, ventura:        "41f38ab1ad90dbc555c72d1cfbae1584876a1ea419a097fcb88dc8ffb1bec6bb"
    sha256 cellar: :any_skip_relocation, monterey:       "623fb5ea6bc27c9201efb733207198ac8db4341918dd5e80a4909492e580db06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c661de650eac222454682916c96f840f44c8bccebbbfe2e833ead437cbc518fb"
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