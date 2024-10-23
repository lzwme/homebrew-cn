class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.0.3.tgz"
  sha256 "e916090da9d37c25cc4a83a62b11345969b68306b557902c417c298bf61fd7b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1d7e96b3a7a9ef0bcab8dbdae9e7a25b39a6bd1fb43f655a314bf61d7411f08"
    sha256 cellar: :any,                 arm64_sonoma:  "f1d7e96b3a7a9ef0bcab8dbdae9e7a25b39a6bd1fb43f655a314bf61d7411f08"
    sha256 cellar: :any,                 arm64_ventura: "f1d7e96b3a7a9ef0bcab8dbdae9e7a25b39a6bd1fb43f655a314bf61d7411f08"
    sha256 cellar: :any,                 sonoma:        "d8720fadbbca6c536f5066a70ca72b88182005b66cb93d988d7b33e8abf6c068"
    sha256 cellar: :any,                 ventura:       "d8720fadbbca6c536f5066a70ca72b88182005b66cb93d988d7b33e8abf6c068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f76f29f5613d859ad3798b0038b41ad0f279a496dc474bbd5b4c2a864aeb0dd"
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