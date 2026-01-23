class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.5.tgz"
  sha256 "d5a6864d177a94cd5bdf13d638c06d4b448f01d09a5b23361ffd38ad8c8ac247"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfa67d9845d9458defe7ec19bf4ecae17382c4b09d26f5d58301ee48a5ce67c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81497a7a5044aba8d5e5831ab146cd58ce6c70bc9286a0386dca192a21efe24f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81497a7a5044aba8d5e5831ab146cd58ce6c70bc9286a0386dca192a21efe24f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b508ba122994582e3a77c1e2040dfdb2510219e698df29e692847d9dec39efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5308f34275841e1cf66cb14aab110d2645fa40793863bdbe4abb548aeba41d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5308f34275841e1cf66cb14aab110d2645fa40793863bdbe4abb548aeba41d56"
  end

  depends_on "node"
  uses_from_macos "zlib"

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