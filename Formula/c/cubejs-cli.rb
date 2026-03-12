class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.22.tgz"
  sha256 "7137ba1e947bf8dd98a370067a55b872d89aec24bcbc310ba5c67bf864679232"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4339a9a9791e6c75512206183795068685d15726cdf4bbbbb17c7042f400a8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b2eeef9bc57a5ee2359748f71cd582ffe80b4534a7e9eddda57daa25570de29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b2eeef9bc57a5ee2359748f71cd582ffe80b4534a7e9eddda57daa25570de29"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5496c57f22d6b8f23269f0e44b8b7cfcf9546f5b421d86f5ec29be7c7542ec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d3f31d344f736606b4046b574e641c3fd2208a2a4eda893af603973b13cd415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d3f31d344f736606b4046b574e641c3fd2208a2a4eda893af603973b13cd415"
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