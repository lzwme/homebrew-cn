class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.38.tgz"
  sha256 "b9fff431b3f671b9e6c37aaf26e993968f38769546a12170b2e6179f5f38f90b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01f25294f501de7e4414a188ccd48b520c063b9d5dd40f7d38d3946c19125624"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b549672ed6eacc62f6e76691ecd4c53850526ef3a673c81edf2b80ca9efd27c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b549672ed6eacc62f6e76691ecd4c53850526ef3a673c81edf2b80ca9efd27c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0691edf9f638826de956c649ffc615ac2748aa693f5bbac53650570f9f9e90c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9296f6e0547721f5673d861fa9e00f1400bc86b2bb20bc36c45798db87f2664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9296f6e0547721f5673d861fa9e00f1400bc86b2bb20bc36c45798db87f2664"
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