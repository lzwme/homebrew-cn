class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.23.tgz"
  sha256 "7a92328bb2adf848b1cba9d6d3837b2a4f8267e95d0d2b1c7975f1dfcdd07bc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18d75c8a627a296f0002bcac834468b7ba3cf53402966571d38e5d5a02357aae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91a8da8cfbc5a9421a129ca200ab3de295e1234ecf8534b9a0314ae240f15e96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91a8da8cfbc5a9421a129ca200ab3de295e1234ecf8534b9a0314ae240f15e96"
    sha256 cellar: :any_skip_relocation, sonoma:        "7019139369727c0ae00dd0fad20e810061dfadc52fff3481fa8f225a10e64ae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1704c2b5d4fbd346fd719f2aa6037530de1cc73d6c0b2b60ac7ccfa7b086995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1704c2b5d4fbd346fd719f2aa6037530de1cc73d6c0b2b60ac7ccfa7b086995"
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