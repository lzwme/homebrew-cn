class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.1.tgz"
  sha256 "86d63d3cc21382c05845b4f10154a14cc8ca70e242487e5318f120a6ecadc5e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbca889b3e5125f2e3751f628376004f93ac24d64f9320e6a34b9c88f6d3f4ad"
    sha256 cellar: :any,                 arm64_sonoma:  "fbca889b3e5125f2e3751f628376004f93ac24d64f9320e6a34b9c88f6d3f4ad"
    sha256 cellar: :any,                 arm64_ventura: "fbca889b3e5125f2e3751f628376004f93ac24d64f9320e6a34b9c88f6d3f4ad"
    sha256 cellar: :any,                 sonoma:        "76c27a6b06352281e64adc2d13a68e6a36d6021ec9d25b562f2dbf6999626bd7"
    sha256 cellar: :any,                 ventura:       "76c27a6b06352281e64adc2d13a68e6a36d6021ec9d25b562f2dbf6999626bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0965c571fbedc3c7aea8e5cdaf845226c4543c7d6bfe570ea3dd2fca78fd2595"
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
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end