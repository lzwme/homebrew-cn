class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.48.tgz"
  sha256 "8da3f3e2b21d28d8f787f3521bcc199de4113b6c9637e6f489ca506c74ca6d1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3abafca3132d0d1f505334e2315a0f1b65265891535d1f710989bf24bce8cd82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6f5e5fed805909a698d46bafe7dc340617de293207ae9b19cd3f81277e70e8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f5e5fed805909a698d46bafe7dc340617de293207ae9b19cd3f81277e70e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "648ef5841be15d8ad3491b093f5496f3c4852440d89386c7ab61112671612c6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ed4632093b4da63ee24c787ff68b5f0df0e684d25322e106b7bfe9a36f3b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8ed4632093b4da63ee24c787ff68b5f0df0e684d25322e106b7bfe9a36f3b06"
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