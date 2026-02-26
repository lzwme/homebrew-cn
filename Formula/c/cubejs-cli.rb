class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.16.tgz"
  sha256 "931efe704f3deab083569c6b2f3061ed5894a5358774f6fbaaf17c755532113a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed71d530a9281dd46826e1a3287f27339a2f3ba65cd36050e447d1eb9d728d7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "737a822e702f4e1e6d38e6549b93b8e7381e0135730c34af8bf7d6469f28d10e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "737a822e702f4e1e6d38e6549b93b8e7381e0135730c34af8bf7d6469f28d10e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b3136daee8fceafd55fff91497d6221536df524e98276911a03210b868c90b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71b760b1e58f5678be32ed8dc22e8ba0c26c1378faff208a9198e771ab8f021b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71b760b1e58f5678be32ed8dc22e8ba0c26c1378faff208a9198e771ab8f021b"
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