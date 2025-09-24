class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.11.2.tgz"
  sha256 "1fc50066457c00c8e45eaa451282af8c3fb24ed6bebc136f0f41374c80729c19"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a51f1273ca9976d82f162b37bbfe4e3584cbee07488b9b6c7e536b2b210b95e4"
    sha256                               arm64_sequoia: "a51f1273ca9976d82f162b37bbfe4e3584cbee07488b9b6c7e536b2b210b95e4"
    sha256                               arm64_sonoma:  "a51f1273ca9976d82f162b37bbfe4e3584cbee07488b9b6c7e536b2b210b95e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "95b8fbab0235b890fcd63992cdf29b23ed683747f3e98fe95cef42899abac977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec5eba349a12a105012ef747f3d6384ce5aa53b2c580a81bf7e21c05406aa97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecfa0b1cb893bc191cc1e81642590207a9ccef2af003197d51003bdc3a63b1fd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end