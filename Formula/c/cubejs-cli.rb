class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.4.tgz"
  sha256 "12e24195563e3e67f691bf5556db6d165202d4f8413e92aac1d7620110be77be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "689d72f60a1273f6eac14843eb8d8bc130db703cbd0e4d1d441c112c9c15e123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "689d72f60a1273f6eac14843eb8d8bc130db703cbd0e4d1d441c112c9c15e123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "689d72f60a1273f6eac14843eb8d8bc130db703cbd0e4d1d441c112c9c15e123"
    sha256 cellar: :any_skip_relocation, sonoma:        "55dc7c06cd9ada519c553c04368741de5f35c7e48ee87cac0a2d68a2beca1d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "086f94a2e7024dc20b01f4924dd9cfbc797052430ba31bd4c02481da3d84d35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "086f94a2e7024dc20b01f4924dd9cfbc797052430ba31bd4c02481da3d84d35a"
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