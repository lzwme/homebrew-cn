class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.3.12.tgz"
  sha256 "ea34216f33bcdeff6a91a82a6d3ebc71f4ce4f40c68a652c5e9719c59371d724"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd7d37909b53300a64a54179a720782e6b94fbaf1089c1b161fea5667bdff518"
    sha256 cellar: :any,                 arm64_ventura:  "cd7d37909b53300a64a54179a720782e6b94fbaf1089c1b161fea5667bdff518"
    sha256 cellar: :any,                 arm64_monterey: "cd7d37909b53300a64a54179a720782e6b94fbaf1089c1b161fea5667bdff518"
    sha256 cellar: :any,                 sonoma:         "8d80549a981ae924d52f4daa6ad8cb49fac23863d2f8461eee4c7986fd5718a8"
    sha256 cellar: :any,                 ventura:        "8d80549a981ae924d52f4daa6ad8cb49fac23863d2f8461eee4c7986fd5718a8"
    sha256 cellar: :any,                 monterey:       "8d80549a981ae924d52f4daa6ad8cb49fac23863d2f8461eee4c7986fd5718a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "985d7e1056095de79f3bd8cd0d0f1df86ded53807be2e168000922c5690bd0f2"
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