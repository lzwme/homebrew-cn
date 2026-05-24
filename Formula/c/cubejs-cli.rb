class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.50.tgz"
  sha256 "b384e48d3865ed514cca6414d00e0362ac825dbbbe5415b1b457dfa301be07f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e21a7e748d568ba50ad3a1c10d9ad4b1b54598ed495394375b392082566f4710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "357b14c600ec7a2bd586313b08ddbf95af0f84185612265f9236ea3954160048"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "357b14c600ec7a2bd586313b08ddbf95af0f84185612265f9236ea3954160048"
    sha256 cellar: :any_skip_relocation, sonoma:        "75fa9490640dc6a5e17d2bc59d917df94df8256cfc67d30cef0933d67bf88bf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87c629c68910e10aa6db98875fe3100ccc97a58b01018e6b5c829294b2a214eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87c629c68910e10aa6db98875fe3100ccc97a58b01018e6b5c829294b2a214eb"
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