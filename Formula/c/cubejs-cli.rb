class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.23.tgz"
  sha256 "6f5a1005b3d38c9ebb4b352d25eba448007275dd2077f6c1b725a58016c53705"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "037778f7500b282d5c9f7e383f401f049e8a59a0bb44d567498d065a324c79da"
    sha256 cellar: :any,                 arm64_sonoma:  "037778f7500b282d5c9f7e383f401f049e8a59a0bb44d567498d065a324c79da"
    sha256 cellar: :any,                 arm64_ventura: "037778f7500b282d5c9f7e383f401f049e8a59a0bb44d567498d065a324c79da"
    sha256 cellar: :any,                 sonoma:        "c70dc30bf6fc2adfc34fe63089b64097532c6a3a9911f28c3df701658b54b756"
    sha256 cellar: :any,                 ventura:       "c70dc30bf6fc2adfc34fe63089b64097532c6a3a9911f28c3df701658b54b756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5108d130ae01d5547b737d8e0f4bfa56b2dd4e8df7590db62179d9a21220c577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad15498b4f277b94f5183a86f80e6832c262cd8876264af5fb84ee188c973aad"
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