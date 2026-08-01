class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.15.tgz"
  sha256 "db57fa853b820b86002a248d0114bea5ad0a1565bfabcb2bb0ec85ceb666663f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a1581013c081a3597694d7fa6c1f4b786b12d39af61435f3a8c22c84443f6d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a1581013c081a3597694d7fa6c1f4b786b12d39af61435f3a8c22c84443f6d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a1581013c081a3597694d7fa6c1f4b786b12d39af61435f3a8c22c84443f6d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6af5b7b184f3abc9712d8f11605d5af92c53244ac7d827ec7c14bb9316d513f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed71fd7b9e4329acedf4620850f30e5bc3b46b47e6da3c60aaabad167fe958dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed71fd7b9e4329acedf4620850f30e5bc3b46b47e6da3c60aaabad167fe958dc"
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