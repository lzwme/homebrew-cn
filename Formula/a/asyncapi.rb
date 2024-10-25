class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.7.4.tgz"
  sha256 "d765067de0929b18484b6ec3d12236cae3bc94754a55153f67a32a2867e6b89f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1adb5efb1fee8677b5d25748ab5d73d62dc913d05ba331680f79bae7021a67cf"
    sha256 cellar: :any,                 arm64_sonoma:  "1adb5efb1fee8677b5d25748ab5d73d62dc913d05ba331680f79bae7021a67cf"
    sha256 cellar: :any,                 arm64_ventura: "1adb5efb1fee8677b5d25748ab5d73d62dc913d05ba331680f79bae7021a67cf"
    sha256 cellar: :any,                 sonoma:        "cfe73310f6af51a79e857347f0b7505acee327188868eb5792e805820f9b9f67"
    sha256 cellar: :any,                 ventura:       "cfe73310f6af51a79e857347f0b7505acee327188868eb5792e805820f9b9f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "023c474c0abb63cdf64673e22b70c5ec7a458bb34a24be2255429b8250002517"
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