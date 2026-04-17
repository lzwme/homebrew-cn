class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.35.tgz"
  sha256 "fc337d8ebea785ce290d11d5c2be51b61ded0e86f04065db117a910d6b121dcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e67b45d9c12769341477fe7eb3e279b14e6e60048a02d8a45009e5a7af27e65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f01894a876fe0e6b3ea0dcea38718344f71e5c6b021611c82946242b2b32cef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f01894a876fe0e6b3ea0dcea38718344f71e5c6b021611c82946242b2b32cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "7173512c62e2ad84baf990e85b0acf4a24dc28cc9537943a885614f969b0ab06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f53b69eed3e78e9762bb9598cdd0d60acbeabf284e43148641c8ff8afd992af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f53b69eed3e78e9762bb9598cdd0d60acbeabf284e43148641c8ff8afd992af"
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