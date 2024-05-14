require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.31.tgz"
  sha256 "4446a36ff987d477363b2d89a1946eeed7b42ad4cc4d7520be7ec29a23ff8c3c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "714d4017feb5046ec806a764c3cf79a987b9b348cef0452c329b04fb7e9ce980"
    sha256 cellar: :any,                 arm64_ventura:  "024c7b2d5a658a173281487337168e1a01e7b6b06c8164fe07b590ae3dc5739e"
    sha256 cellar: :any,                 arm64_monterey: "f6496653d9705d1d02d0a48b1f857aa028b1547bc2757a54ee24175baf59f447"
    sha256 cellar: :any,                 sonoma:         "d94bd2c964ef09cd4ace5630e506768ec4c42ff3e2a7b78c2dead013dacbd414"
    sha256 cellar: :any,                 ventura:        "06d72298764923220b32dfe012df7cb3ecd8156f26357cc6f424b046887e497b"
    sha256 cellar: :any,                 monterey:       "0fdff8163dc8e02e96930a525ef2c65bcb35e542a290716dec331f9e89359461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e84a3525275e16c45a129372ea44c96a560da9165651418f0583ace77a1a7a36"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end