class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.2.tgz"
  sha256 "66a3da2077ba707d12778e5e2298451a88b225c6fbf3abb9fa6b761ab24056c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "893fc102f44b102c79f655fcec010140765c5ce5920b734b431eb1ab5a4375ca"
    sha256 cellar: :any,                 arm64_sonoma:  "893fc102f44b102c79f655fcec010140765c5ce5920b734b431eb1ab5a4375ca"
    sha256 cellar: :any,                 arm64_ventura: "893fc102f44b102c79f655fcec010140765c5ce5920b734b431eb1ab5a4375ca"
    sha256 cellar: :any,                 sonoma:        "9ef594f406ba12cb5d487beea0d99f30622e519aabcfb29223cf3d2abce11609"
    sha256 cellar: :any,                 ventura:       "9ef594f406ba12cb5d487beea0d99f30622e519aabcfb29223cf3d2abce11609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1082a8b71ca775580a9b4af44dfc8f92d458d9eda6525f194f1d008655173344"
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