class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.51.tgz"
  sha256 "bd7cde40897bb24a75979280962518fb0e1a819a8af6113e641864428d810086"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1beddc9bc27e7e1a05d5b740b829e3a6553464d9d2f65c36d9e6c508832933f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe075c222c9829f75e25b9ce444ae70b90613ee6329bbbaa595828ef4181c8ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe075c222c9829f75e25b9ce444ae70b90613ee6329bbbaa595828ef4181c8ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "f57e2a6331fe706c10847d91fddbef2658048ea5e7b714951366707009625475"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc4f34992d1c38afc8129f56f38e6fc8620be60422ecc6b7da305495bbb74cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc4f34992d1c38afc8129f56f38e6fc8620be60422ecc6b7da305495bbb74cd"
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