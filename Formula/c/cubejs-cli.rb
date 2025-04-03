class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.29.tgz"
  sha256 "1ea2550f5f670abac913802988d179ed7129e078cd5e9af9dbe1e92f1795e9d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ebb81f11c46d414e45b9edbbf2cc7fda54dda69c19bbd2275bcbdad85c14659a"
    sha256 cellar: :any,                 arm64_sonoma:  "ebb81f11c46d414e45b9edbbf2cc7fda54dda69c19bbd2275bcbdad85c14659a"
    sha256 cellar: :any,                 arm64_ventura: "ebb81f11c46d414e45b9edbbf2cc7fda54dda69c19bbd2275bcbdad85c14659a"
    sha256 cellar: :any,                 sonoma:        "f0ff8ea834867a13ae31bcfb4a6b8ab29dcf7cce74e04858397fee4680e6a26e"
    sha256 cellar: :any,                 ventura:       "f0ff8ea834867a13ae31bcfb4a6b8ab29dcf7cce74e04858397fee4680e6a26e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf9dff046c23020a76f7dffa8a5285482d86b16c712fb95d704e614c0d2d468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b83ee767ece5981e60013176fa8e495b7935f9df74ba60fb7e115267e394274e"
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