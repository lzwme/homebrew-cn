class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.3.13.tgz"
  sha256 "b883ce938247f5bd3eeb7a7c23395c7a997517a3f5ca36657b22f440ccb98ecd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f08158fcfc581fc39cc72bdf7c7f88c1514eab6aab9d8107b34426e89616b6c1"
    sha256 cellar: :any,                 arm64_sonoma:  "f08158fcfc581fc39cc72bdf7c7f88c1514eab6aab9d8107b34426e89616b6c1"
    sha256 cellar: :any,                 arm64_ventura: "f08158fcfc581fc39cc72bdf7c7f88c1514eab6aab9d8107b34426e89616b6c1"
    sha256 cellar: :any,                 sonoma:        "6eb680ef5533f6785d7640a3f39af0b8d2a0a7a7d9a00e3a17412bdf6e653c3f"
    sha256 cellar: :any,                 ventura:       "6eb680ef5533f6785d7640a3f39af0b8d2a0a7a7d9a00e3a17412bdf6e653c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5477adfe0677cf8ecdd222b827bee346dbf7849d207956f74d212156e61e7ace"
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