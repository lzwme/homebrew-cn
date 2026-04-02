class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.30.tgz"
  sha256 "621a9e8858cb1ebe9c82d70e3674d0f100a11b7e0f1a15ac1233926622053746"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a6a4ad0a58d66be6b1d716db0f42f1c25adf5a5d1be013ba84c39bc6fa20bc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5da6cd44d6b93296f7d9e10a336efa5a35ef59f84492229308062f9f4b22e2d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5da6cd44d6b93296f7d9e10a336efa5a35ef59f84492229308062f9f4b22e2d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "48bfd5e5d00efb91d9c4f18d5b38377d174ba2bc656afab28e8bb91c8e93de8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df1d402dcb34d44db269722ae60c5f2bf7cea40713fd4b3d5875ef680fdfdaa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df1d402dcb34d44db269722ae60c5f2bf7cea40713fd4b3d5875ef680fdfdaa9"
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