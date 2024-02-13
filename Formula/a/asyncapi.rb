require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.5.3.tgz"
  sha256 "62db23f727bc318cccd7c352abfb18e99bdc27c14a8d73ee88f129ed167f8603"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7593489b670014adf213dc293ee5716770afd0dc91281648d35d55a870b272c4"
    sha256 cellar: :any,                 arm64_ventura:  "7593489b670014adf213dc293ee5716770afd0dc91281648d35d55a870b272c4"
    sha256 cellar: :any,                 arm64_monterey: "7593489b670014adf213dc293ee5716770afd0dc91281648d35d55a870b272c4"
    sha256 cellar: :any,                 sonoma:         "e4f810d0bd98bd67556d8a738ce9afda06854c9e6b5e07ffea4959081dbe1d97"
    sha256 cellar: :any,                 ventura:        "aec93f0cd73be41d8f5abd6fa5adbd9d39e4695a898747db4f89ce350b4c9819"
    sha256 cellar: :any,                 monterey:       "e4f810d0bd98bd67556d8a738ce9afda06854c9e6b5e07ffea4959081dbe1d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a495a25d3d3f84f8045c76b0fa9f164abcc223a752fb98308660c74a68e9b8cc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    (node_modules"@swccore-linux-x64-muslswc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end