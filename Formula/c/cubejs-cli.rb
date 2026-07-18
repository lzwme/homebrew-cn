class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.3.tgz"
  sha256 "3d2fca37b5da7899be5769f54eecda50560c4b28a4a72bbe1383b78a27022f2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8da4e36f9daaca21aa71febf85a8ab8976fd98a4fea2d2ac481475e2b665953a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8da4e36f9daaca21aa71febf85a8ab8976fd98a4fea2d2ac481475e2b665953a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8da4e36f9daaca21aa71febf85a8ab8976fd98a4fea2d2ac481475e2b665953a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f618586175293f2e09dd163b195e065a0fdb8eddee3d549cdd5c244cba97a46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea7c273dbcc2a2784c423609d639815ba592cfd6a0d7b1b38b2cde87bd7a705b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea7c273dbcc2a2784c423609d639815ba592cfd6a0d7b1b38b2cde87bd7a705b"
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