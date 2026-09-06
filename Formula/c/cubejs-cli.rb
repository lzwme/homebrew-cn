class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.34.tgz"
  sha256 "14bba4cdb9e76cd3c5fb29008eb055896c2e4e538fb3952cd9f7fc2f9429e269"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e12769699dc316e099e4df832c1a65b858008f44f4704df8b80b4724a6a515"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e12769699dc316e099e4df832c1a65b858008f44f4704df8b80b4724a6a515"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e12769699dc316e099e4df832c1a65b858008f44f4704df8b80b4724a6a515"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b098d4ab8badb2d69e794c85277f4367b5e282f6c7bfe11d7c59d2a55f92a7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b098d4ab8badb2d69e794c85277f4367b5e282f6c7bfe11d7c59d2a55f92a7d0"
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