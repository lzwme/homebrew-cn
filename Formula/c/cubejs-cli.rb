class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.18.tgz"
  sha256 "bf68d610f1b42fb005fc0e6e437a6ef387245bd860f5ed8772deab7eabebd33a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "354d9cfe5840614b618b622299fc965cea083de6dba8f362c0bf8378d6e9c35a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2f12489f80a3444c1bb89ee338392638b44f2734a1ceb59e0242c9eb0ba6e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b2f12489f80a3444c1bb89ee338392638b44f2734a1ceb59e0242c9eb0ba6e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "69195d8ad7901f40444b83a3f2325f5227f69a79c39dac0839cd35c8d1526faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57dd9446707ba8360dbca4ed28bfc1c5b799708e6fccf03ba1d013d7eff00ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57dd9446707ba8360dbca4ed28bfc1c5b799708e6fccf03ba1d013d7eff00ab8"
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