class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.3.tgz"
  sha256 "d3e5b17de843d7230babb6f6604c3aa4c6d5acff627b934a8eb3ae302ae80b4f"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "177216e49adbd52e55ad3923c09c5329025e311014c2483557262ce083812b7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "177216e49adbd52e55ad3923c09c5329025e311014c2483557262ce083812b7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "177216e49adbd52e55ad3923c09c5329025e311014c2483557262ce083812b7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c750b3bd304310b5af1aa4cf98af9554c62929a0f218bfd41246a0aa1fa7d08"
    sha256 cellar: :any_skip_relocation, ventura:        "8c750b3bd304310b5af1aa4cf98af9554c62929a0f218bfd41246a0aa1fa7d08"
    sha256 cellar: :any_skip_relocation, monterey:       "6471f4b92badf80beb23471251dd60c597fdae1c925af862fdbf87ca5d546f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a988eec16401dc6cb35774d5548fb4ec33eac3606743ac4a371faab1b01a5685"
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