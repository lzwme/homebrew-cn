class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.107.6.tgz"
  sha256 "32e98050ed2c2f6c3ac168d7ad19e566d8f793386d17b24004cb3dd2252eb413"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff5d4730ad85df0eda41ea7e4025221609cca25cebfb3730945d5658f8660600"
    sha256 cellar: :any,                 arm64_sonoma:  "16596fed5c370e4d256c4f378d78626c8ec6272ddaa49a54f24993fc98d0a43a"
    sha256 cellar: :any,                 arm64_ventura: "fb1e42adf0c2011c378439b046c730fa90255f17ca2ec57e0aaee02760a323ec"
    sha256                               sonoma:        "4458484bdf1f4fdf6f5ab5818215ec8ac949d1a396e419bf740f74ad4ef2120a"
    sha256                               ventura:       "fe4cd0068597a4484cbe163c19ef060113d2a15d8605aee9a0827cbfda66d930"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9c25072bc2584f517ba97386d88f70f4292498abe2870e9075033c3f8901878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426368290051114d91fab908ea184e72a00852c25eda60b3054be8e60d3f4fef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end