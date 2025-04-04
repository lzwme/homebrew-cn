class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.8.3.tgz"
  sha256 "27a8cfc79324a98743d2097fdaa08a97a557a184f035459eb975daec8aca5176"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a9053774ec39ab4798a2a33db7b74bac75b86cec241046fc723537774be0963"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a9053774ec39ab4798a2a33db7b74bac75b86cec241046fc723537774be0963"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a9053774ec39ab4798a2a33db7b74bac75b86cec241046fc723537774be0963"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ebb2d08ad91860511b403af3449c7cd94b040c392671a531f482b71e420fe24"
    sha256 cellar: :any_skip_relocation, ventura:       "5ebb2d08ad91860511b403af3449c7cd94b040c392671a531f482b71e420fe24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a9053774ec39ab4798a2a33db7b74bac75b86cec241046fc723537774be0963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6821b3fa3f260f7bcec1ccfdd1e19e4de3cac91ce18863c2992831988f32249"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end