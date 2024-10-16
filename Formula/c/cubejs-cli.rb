class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.0.0.tgz"
  sha256 "83f1b11920c1a5e244a07338d65efa6deaee7d78fe4094eb0b3ce60d0d7bab1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bad3063dde0abb7befeea2f1854bcd88b52ef7c132603466b58b2edfcbba0f71"
    sha256 cellar: :any,                 arm64_sonoma:  "bad3063dde0abb7befeea2f1854bcd88b52ef7c132603466b58b2edfcbba0f71"
    sha256 cellar: :any,                 arm64_ventura: "bad3063dde0abb7befeea2f1854bcd88b52ef7c132603466b58b2edfcbba0f71"
    sha256 cellar: :any,                 sonoma:        "bbf8aad9e2b4d778ad0adda2c603022652eb2f8c3ebf692e4d2c2bdb8c21b9be"
    sha256 cellar: :any,                 ventura:       "bbf8aad9e2b4d778ad0adda2c603022652eb2f8c3ebf692e4d2c2bdb8c21b9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f697fb8fc84d71172d7454363f5f574b2fe03dc0def7509136e179986f3853"
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