require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1259.0.tgz"
  sha256 "27f233fd7276575181c7c2cde9760b3f55c31bb1e9edebf5d358464f3a7cc3d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21c0b8c91ef7874eedd4844fe6b8f16800f04bae3b43b69eae4d6a4596beb3bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a97905a2b19c306b07c3ae8afcacb72316fb73b50b6b80d659515e3a71e5389"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02e0110f7dee34b30b48b3f2b0342607d6dcfb059b91f219d4ac4ba420879dbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2eb0923e279dcb32d86565326efef9b21ba17528a760edc17831daba2239f87"
    sha256 cellar: :any_skip_relocation, ventura:        "cd1e685f7fb759ca752693818548ea61f1d10d6795dd2a6d6c1f6a9ec07478c0"
    sha256 cellar: :any_skip_relocation, monterey:       "66e583df8d444260cc68efa231c0209f31955ae0f9819ef6803ae0378cdd2355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4137d3f18b29b19d96205e02897eb78df97b98c612dea21f631b8038eee77c54"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end