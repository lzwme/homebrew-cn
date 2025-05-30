class PrismCli < Formula
  desc "Set of packages for API mocking and contract testing"
  homepage "https:stoplight.ioopen-sourceprism"
  url "https:registry.npmjs.org@stoplightprism-cli-prism-cli-5.14.2.tgz"
  sha256 "61a3b45fbb0325b85fbe94baf836588de676c0db91c3b1f191738070c2f7410f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea3b321d160363a5e006b5166598ce3c14fd567390622e0393f6824329768730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea3b321d160363a5e006b5166598ce3c14fd567390622e0393f6824329768730"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea3b321d160363a5e006b5166598ce3c14fd567390622e0393f6824329768730"
    sha256 cellar: :any_skip_relocation, sonoma:        "71efe36b05538b5c2cc27803232915af9558f28edeba405272a0fbbbaed043b7"
    sha256 cellar: :any_skip_relocation, ventura:       "71efe36b05538b5c2cc27803232915af9558f28edeba405272a0fbbbaed043b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea3b321d160363a5e006b5166598ce3c14fd567390622e0393f6824329768730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3b321d160363a5e006b5166598ce3c14fd567390622e0393f6824329768730"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Backport https:github.comstoplightiojson-schema-ref-parsercommitab6ad5a312672c37fd5936d3cef78fbf0ad85234
    node_modules = libexec"libnode_modules@stoplightprism-clinode_modules"
    inreplace node_modules"@stoplightjson-schema-ref-parserlibresolvershttp.js",
      'const { AbortController } = require("node-abort-controller");',
      ""
  end

  test do
    port = free_port
    pid = spawn bin"prism", "mock", "--port", port.to_s, "https:raw.githubusercontent.comOAIOpenAPI-Specificationrefstags3.1.1examplesv3.0petstore.yaml"

    sleep 5
    sleep 15 if OS.mac? && Hardware::CPU.intel?

    system "curl", "http:127.0.0.1:#{port}pets"

    assert_match version.to_s, shell_output("#{bin}prism --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end