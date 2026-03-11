class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.20.tgz"
  sha256 "b63cc9bd4fc11b7cfcedcc657897526fee797f8e6f1a4f63ac4ab3150adf4519"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5765b6e09a73a21b7e32ef3ac8f6f931554f6f41adec5a9bfa14c41b4aecc5fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b2594762aa7ed80445f791f7f50f1d4c1cc8227a449df9b5dd7a57933b5492b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b2594762aa7ed80445f791f7f50f1d4c1cc8227a449df9b5dd7a57933b5492b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1531911c05d91b9a3cc318d471c2dc7caf222a995d9df92586f334d1f1dac304"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaaa47aa3a8a21d0d8ea48cdab719fa5f673967e950ae815b5d76efc94c593d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaaa47aa3a8a21d0d8ea48cdab719fa5f673967e950ae815b5d76efc94c593d0"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end