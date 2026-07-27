class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.11.tgz"
  sha256 "7723e1b167dba9482a08c7e0198f0b840c527680b16cb91346d5a1df98537a16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e97cfd5ddc615673e98e3c23c5aeca8171b7e432f3d15501c2cee8451d3818e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e97cfd5ddc615673e98e3c23c5aeca8171b7e432f3d15501c2cee8451d3818e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e97cfd5ddc615673e98e3c23c5aeca8171b7e432f3d15501c2cee8451d3818e"
    sha256 cellar: :any_skip_relocation, sonoma:        "73f159d68944455c745623d85101b1dcfd5146aa4983f25fa9622bf2beca933d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df0227377913edff5859425185124f3cad04f136ab3be1650f4c0c048f8672b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df0227377913edff5859425185124f3cad04f136ab3be1650f4c0c048f8672b6"
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