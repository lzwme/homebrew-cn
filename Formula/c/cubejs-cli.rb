class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.16.tgz"
  sha256 "860c4a3449e2c6923e553c37927a4fc72f4eb278156dc583a4dc7061713758da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4098a4464247ff054f809d16d2b60b8e9714cd06061d075205f4e644013d7bde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4098a4464247ff054f809d16d2b60b8e9714cd06061d075205f4e644013d7bde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4098a4464247ff054f809d16d2b60b8e9714cd06061d075205f4e644013d7bde"
    sha256 cellar: :any_skip_relocation, sonoma:        "e64023e576f5bdd053cfeaae2ba465609158ba55156b50e15fe43f4d427ca8f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bc75ca616a6b8d01e634730942620a06de0df937b08a93cf5607eadbd4e0415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bc75ca616a6b8d01e634730942620a06de0df937b08a93cf5607eadbd4e0415"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end