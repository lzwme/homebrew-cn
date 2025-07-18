class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.6.0.tgz"
  sha256 "df41df4d0e2bad86f0c8dd18bd0c9d84c45f90b7bc59762e52ddd18d2ce2027c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bb009bcbcd1e8bab8f55946a06abd9c88428b8f31e483670b8e7fc1084b0b93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bb009bcbcd1e8bab8f55946a06abd9c88428b8f31e483670b8e7fc1084b0b93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bb009bcbcd1e8bab8f55946a06abd9c88428b8f31e483670b8e7fc1084b0b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "09eb87baf25f3c460a9a2b0d5f43056dc0f168d51eb7202293d8d4dd63271264"
    sha256 cellar: :any_skip_relocation, ventura:       "09eb87baf25f3c460a9a2b0d5f43056dc0f168d51eb7202293d8d4dd63271264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bb009bcbcd1e8bab8f55946a06abd9c88428b8f31e483670b8e7fc1084b0b93"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end