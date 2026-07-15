class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.2.tgz"
  sha256 "c8b8756822a60590c352f85960cb12f974fb40e99a9d64cb62946f3854ee9a3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3945e3e0fe564de4f826756d84c37b5012804525f626002c7db441da089c57d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3945e3e0fe564de4f826756d84c37b5012804525f626002c7db441da089c57d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3945e3e0fe564de4f826756d84c37b5012804525f626002c7db441da089c57d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "451f6a662d7c674db9074fc47d8d8aeb76d2323bfdd3fc4615b0029be65d965d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1515f38fc6d8fd9abbd3eef05f0086e4a6b31cd3fcd8034af0b877cf6f97fb7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1515f38fc6d8fd9abbd3eef05f0086e4a6b31cd3fcd8034af0b877cf6f97fb7b"
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