class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.38.tgz"
  sha256 "16c91359e6ac8c624adbf2a0fd29f05f20b36d6c350c9f09083df728e24b0a02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93750326fe78d25a7682856ce702ca8ae3f0f5e4212fe343f0de5d55e691eef7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93750326fe78d25a7682856ce702ca8ae3f0f5e4212fe343f0de5d55e691eef7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "93750326fe78d25a7682856ce702ca8ae3f0f5e4212fe343f0de5d55e691eef7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37718c2e7e61ab2154808f5734536da32b5539e94bd6372748de097678586ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "37718c2e7e61ab2154808f5734536da32b5539e94bd6372748de097678586ea3"
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