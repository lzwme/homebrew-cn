class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.44.tgz"
  sha256 "ebe52dc067052800f932b75d5b69b7ebe8a073f23b989e7f954a1c37f03abf0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7981fcddef761c29e81c623c7dc5ccfe0006ac41efd1cf5b4b9d774515da3ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7981fcddef761c29e81c623c7dc5ccfe0006ac41efd1cf5b4b9d774515da3ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7981fcddef761c29e81c623c7dc5ccfe0006ac41efd1cf5b4b9d774515da3ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce6be70aece6daabe1995bfd417634f184b571a211014b188947dbdfcb1b0369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ce6be70aece6daabe1995bfd417634f184b571a211014b188947dbdfcb1b0369"
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