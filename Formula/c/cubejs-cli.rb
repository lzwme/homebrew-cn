class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.43.tgz"
  sha256 "e077870bcffd3e5c1dbc9b0fec2bdfa1b7f470309e127655c98f58bb4c78794d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34f736f63cfd795bafaa0f4eaca6b7277273f17624540db9bba0aab4cd73a0d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34f736f63cfd795bafaa0f4eaca6b7277273f17624540db9bba0aab4cd73a0d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "34f736f63cfd795bafaa0f4eaca6b7277273f17624540db9bba0aab4cd73a0d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ca597ce508c6c8c167e8fbc80bed30039c008dcacc58c9047767079113d949d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4ca597ce508c6c8c167e8fbc80bed30039c008dcacc58c9047767079113d949d"
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