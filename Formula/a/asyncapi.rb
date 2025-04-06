class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-3.1.0.tgz"
  sha256 "e9ffee10683ef9bdb97cafb19a4c3046b6e90cc92cf778696086e0e1afd16e4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0bff8b9cb9ebcd8afbdb064897c62ac41068b09e01427ebba5f1255c31a9fc0"
    sha256 cellar: :any,                 arm64_sonoma:  "a0bff8b9cb9ebcd8afbdb064897c62ac41068b09e01427ebba5f1255c31a9fc0"
    sha256 cellar: :any,                 arm64_ventura: "a0bff8b9cb9ebcd8afbdb064897c62ac41068b09e01427ebba5f1255c31a9fc0"
    sha256 cellar: :any,                 sonoma:        "046898eeb40e36ffdfe28509a8d9856abc5fce78f18045b4f27080eb5a4099b4"
    sha256 cellar: :any,                 ventura:       "046898eeb40e36ffdfe28509a8d9856abc5fce78f18045b4f27080eb5a4099b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f018bca7ce9121001748a8e90cbd4636f450bf5f56610338a38dcaeb72fe1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b26e7065b3aba14fb6e6becb7f1ac5a618b9a4be7e567015cf76224b4a7328"
  end

  depends_on "node"

  def install
    system "npm", "install", "--ignore-scripts", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Cleanup .pnpm folder
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    rm_r (node_modules"@asyncapistudiobuildstandalonenode_modules.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules"fseventsfsevents.node"
  end

  test do
    system bin"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath"asyncapi.yml", "AsyncAPI file was not created"
  end
end