class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.47.tgz"
  sha256 "30195cb6cb9edc19c25592898d1b19f0a6687cc75e03b4e1e0385522ae34a08f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd8c4f52046cdd9679cea5fcf985e66ce3e604d22111eb8e2e075b342c6830c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd8c4f52046cdd9679cea5fcf985e66ce3e604d22111eb8e2e075b342c6830c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd8c4f52046cdd9679cea5fcf985e66ce3e604d22111eb8e2e075b342c6830c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64bc65685c621f7b2bf8e9cd58cb8ac535f2cb0d2c4410d4394df3813c07d21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "64bc65685c621f7b2bf8e9cd58cb8ac535f2cb0d2c4410d4394df3813c07d21e"
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