class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.0.tgz"
  sha256 "91512f50a92a6a555ee28a3e5b9740a9918dbca5d79e9b52557052ff288b086a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c19e6b9c95bc9ec97cca0072732fb034bb761b39ae482b6adcc9dc0d69a14c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61b8f8e0e5282f7e5a1e4c19c14cb0b30bf70907c279c10a4b913382d40e47cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b8f8e0e5282f7e5a1e4c19c14cb0b30bf70907c279c10a4b913382d40e47cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fab340c143d13959efe69c7c8f972aab36e6ec22582a4fbda65f936b072f305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82d4445a09fdb78e920641af2a7c0f7af26f52864b6a5189004c7ffbb798ce1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d4445a09fdb78e920641af2a7c0f7af26f52864b6a5189004c7ffbb798ce1f"
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