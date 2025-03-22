class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.26.tgz"
  sha256 "561c4cbd7aa9fdb4c245861041d73570815cc3a0f2600e50d76477bac60f49eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bc7938c06d3777737445ca40b52f45a613ddf69c2d7e973c0992a0c667917fd"
    sha256 cellar: :any,                 arm64_sonoma:  "5bc7938c06d3777737445ca40b52f45a613ddf69c2d7e973c0992a0c667917fd"
    sha256 cellar: :any,                 arm64_ventura: "5bc7938c06d3777737445ca40b52f45a613ddf69c2d7e973c0992a0c667917fd"
    sha256 cellar: :any,                 sonoma:        "eb00709e10d45bbe872397a8097535a9621af6c5f510b2b0ca8d27ec13e47c4f"
    sha256 cellar: :any,                 ventura:       "eb00709e10d45bbe872397a8097535a9621af6c5f510b2b0ca8d27ec13e47c4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6012403e8c944d28b7a7aae38f35315dfee7166e45a0b593d1dfadf81c5f3333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca26b905a7b2e893ee1c7980cba426e80a9b4bb8501ac9c362d80900dd3ca9c"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end