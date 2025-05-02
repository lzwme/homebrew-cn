class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.10.tgz"
  sha256 "b9ecdd553c209587d066a91e981a81ecdbc130f896d8d9f701df52ee6cf47c40"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "efc7649be064989de6f13cbbacbd5730a947124488b8fbd66c657aa5a306be9a"
    sha256 cellar: :any,                 arm64_sonoma:  "efc7649be064989de6f13cbbacbd5730a947124488b8fbd66c657aa5a306be9a"
    sha256 cellar: :any,                 arm64_ventura: "efc7649be064989de6f13cbbacbd5730a947124488b8fbd66c657aa5a306be9a"
    sha256 cellar: :any,                 sonoma:        "3155b96e1635cbe80a4b0661d4af45cbc682c8c77574ea352ab41453985b89e4"
    sha256 cellar: :any,                 ventura:       "3155b96e1635cbe80a4b0661d4af45cbc682c8c77574ea352ab41453985b89e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4f707186c62b33f79ca9a4d8517226e1099ab335600286f2b06035973a98dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bc87871beb1805e6800c259b504b974a7fdb9847a12903fc441bd97937d4f5f"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end