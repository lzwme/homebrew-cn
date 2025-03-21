class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.17.0.tgz"
  sha256 "96d16885b2199d7490abc74f39cc9204326cf3574cc5959d8014282237b80653"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "600b14d0077d9ec6374c779058e3df9fad2314d10115fc4f1e10653bff090142"
    sha256 cellar: :any,                 arm64_sonoma:  "600b14d0077d9ec6374c779058e3df9fad2314d10115fc4f1e10653bff090142"
    sha256 cellar: :any,                 arm64_ventura: "600b14d0077d9ec6374c779058e3df9fad2314d10115fc4f1e10653bff090142"
    sha256 cellar: :any,                 sonoma:        "e290c9b25babf8ec49ab9a599025973b57e9771cebfd0a712cf2dec98d536c3e"
    sha256 cellar: :any,                 ventura:       "e290c9b25babf8ec49ab9a599025973b57e9771cebfd0a712cf2dec98d536c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e99f9eb27f6e3866bba9a55cdf79f3364f2cd2a6a17562854df8193dd9bfabd7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Cleanup .pnpm folder
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    rm_r (node_modules"@asyncapistudiobuildstandalonenode_modules.pnpm") if OS.linux?
  end

  test do
    system bin"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath"asyncapi.yml", "AsyncAPI file was not created"
  end
end