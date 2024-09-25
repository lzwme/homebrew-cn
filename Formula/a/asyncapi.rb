class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.4.1.tgz"
  sha256 "e2591e1bbcf43e51b5fb9007b5e5794c2889360e416829327dac19367eb54fc1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d619ee98842afb857d11146716095def0f52fe3746691331c55e4d6d77c12420"
    sha256 cellar: :any,                 arm64_sonoma:  "d619ee98842afb857d11146716095def0f52fe3746691331c55e4d6d77c12420"
    sha256 cellar: :any,                 arm64_ventura: "d619ee98842afb857d11146716095def0f52fe3746691331c55e4d6d77c12420"
    sha256 cellar: :any,                 sonoma:        "018c2e836e3e75b0f8baaf2a35441449309b4dd59b2caf8da7dc52ffa9a0fad6"
    sha256 cellar: :any,                 ventura:       "018c2e836e3e75b0f8baaf2a35441449309b4dd59b2caf8da7dc52ffa9a0fad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c3c22e6b9d0f727b63b8170c92b6ff65af8ba1378912a6bccd213661384183"
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