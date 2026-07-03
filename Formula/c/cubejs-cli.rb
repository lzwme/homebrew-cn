class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.65.tgz"
  sha256 "cbd27572cd8c4def11070c789670b68ea1a8dfb105af06a26519bacbffc96f9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7544fc4de4709e7f9001b8d113aa9fc1861a45ca7ac56592187a2844ecca17cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23bc3b489b3444f86c86d7266817d5b52862fd6bdc3160a0ce2149a42533e2e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23bc3b489b3444f86c86d7266817d5b52862fd6bdc3160a0ce2149a42533e2e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3772831ed064208213bd188a28135572390739a73ba8addbd3bb11503d8debe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2764d0be300920498e4120b5ef4c8e93a8683a7b5b542b7586e3423d1aac3f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2764d0be300920498e4120b5ef4c8e93a8683a7b5b542b7586e3423d1aac3f5d"
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