class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.14.0.tgz"
  sha256 "02dae8122d985ec0a9a7dcf4b9598288eb8217ba6550de2ac843b01ae208576c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "047fa6358ca392516437105720e829ef0886c7e65c4e461ea5251c3e6889f527"
    sha256 cellar: :any,                 arm64_sonoma:  "047fa6358ca392516437105720e829ef0886c7e65c4e461ea5251c3e6889f527"
    sha256 cellar: :any,                 arm64_ventura: "047fa6358ca392516437105720e829ef0886c7e65c4e461ea5251c3e6889f527"
    sha256 cellar: :any,                 sonoma:        "e04892119797667ab60674855f783b8877d1e35e54d03f7a1367c314c80ad9c3"
    sha256 cellar: :any,                 ventura:       "e04892119797667ab60674855f783b8877d1e35e54d03f7a1367c314c80ad9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a956198078a1a870b136986a0d57dd33c26cbc092619defe5bfd36197862956f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end