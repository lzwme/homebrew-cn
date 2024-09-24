class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.4.0.tgz"
  sha256 "383f4df03c2238a7eccdc55bf08ee6944f767f4f0df539bb7a1a8daca00a7cd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89823317088f181079c62a6bf3e96f65f13acf39adf46cc6a9cf61b5cd42afaf"
    sha256 cellar: :any,                 arm64_sonoma:  "89823317088f181079c62a6bf3e96f65f13acf39adf46cc6a9cf61b5cd42afaf"
    sha256 cellar: :any,                 arm64_ventura: "89823317088f181079c62a6bf3e96f65f13acf39adf46cc6a9cf61b5cd42afaf"
    sha256 cellar: :any,                 sonoma:        "5232a34fd5300fc4b0c3c0769594b719e118e512b08ef045ecfe39b688f5d781"
    sha256 cellar: :any,                 ventura:       "5232a34fd5300fc4b0c3c0769594b719e118e512b08ef045ecfe39b688f5d781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4386ebc81b46399f5e9bb065f080e5bc1a478aef9f49459e07101a6bf87d77f0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end