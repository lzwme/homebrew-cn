class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.43.tgz"
  sha256 "aae4e0bf3dcbc419a085d564b431bb8d1bb60a929cbe5a33cc99c1e899b1422f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5387a1e88b8d73ce5513dc82df331a53f43f55db80e1eda9a98d520bbc5f6f0b"
    sha256 cellar: :any,                 arm64_sonoma:  "5387a1e88b8d73ce5513dc82df331a53f43f55db80e1eda9a98d520bbc5f6f0b"
    sha256 cellar: :any,                 arm64_ventura: "5387a1e88b8d73ce5513dc82df331a53f43f55db80e1eda9a98d520bbc5f6f0b"
    sha256 cellar: :any,                 sonoma:        "05f34c83662afc353e9c0a472cd97dadc8e187d0533811dbaf218981e8180213"
    sha256 cellar: :any,                 ventura:       "05f34c83662afc353e9c0a472cd97dadc8e187d0533811dbaf218981e8180213"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a360f5ee433e7e5e5145aed12cb2d6a899d78cd4c8178ef3e86268c0a293ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e47586a724f6adbb1633614d68fd48a24a29e56d2e14beb1341af8419ee4cb2a"
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