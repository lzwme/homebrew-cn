class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-3.0.0.tgz"
  sha256 "907792742a44feb2c610fbb1b50275aacc8a655ea5e50682a09a2d2f67bd1c52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "07ab7a00dbc0c15b54d5032c8ed1fd8068f2cfde039d17848710e1095b8329be"
    sha256 cellar: :any,                 arm64_sonoma:  "07ab7a00dbc0c15b54d5032c8ed1fd8068f2cfde039d17848710e1095b8329be"
    sha256 cellar: :any,                 arm64_ventura: "07ab7a00dbc0c15b54d5032c8ed1fd8068f2cfde039d17848710e1095b8329be"
    sha256 cellar: :any,                 sonoma:        "935b90e164c0c5974c42e903c4f2d9f3df204eeeec608a051bda11aed8a59758"
    sha256 cellar: :any,                 ventura:       "935b90e164c0c5974c42e903c4f2d9f3df204eeeec608a051bda11aed8a59758"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07ff613a65e1cb206ab61292c27649e57e4333f8fac31a5c4c1d994cdee12a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a98451b376c15db26f89d0b227ac165fcdbd2664b25fe2de260e7d14341ae884"
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