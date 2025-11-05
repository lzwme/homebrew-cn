class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.1.tgz"
  sha256 "cc7b1817e0694cb87b7d1a0b2d8536dac52535c17ca71f01a448992985b121c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33d6ea80c7761744cf1b6acb232c16252c7fffa8ab0f400844e366a0c46603e6"
    sha256 cellar: :any,                 arm64_sequoia: "a5642d55fd2036d7337cae80f101aa5a3b98cc4014457dc5977bb0535e0c1f54"
    sha256 cellar: :any,                 arm64_sonoma:  "a5642d55fd2036d7337cae80f101aa5a3b98cc4014457dc5977bb0535e0c1f54"
    sha256 cellar: :any,                 sonoma:        "0a3b223e741dc8580d73c750ce63ed4ae9af340d48682a2a65aa3e1ab05ad1f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "869caa00d38151d120b6cf439cde00e9c4bfc219a90a5a7f58377dc022c4b37e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d98666fe3305db50a538fb929a98cc854cb0ae9ea82e99e030b07f00e676865"
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