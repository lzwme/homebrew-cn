class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.65.tgz"
  sha256 "8124c000d0b05c0a8d354edc2dbb346bee1220eca767da68f17d44866b7d8b57"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "90d2bbd8e38569f864aa54184634d850c1ba3389e91641bfd3a60c7bb07956af"
    sha256 cellar: :any,                 arm64_ventura:  "90d2bbd8e38569f864aa54184634d850c1ba3389e91641bfd3a60c7bb07956af"
    sha256 cellar: :any,                 arm64_monterey: "90d2bbd8e38569f864aa54184634d850c1ba3389e91641bfd3a60c7bb07956af"
    sha256 cellar: :any,                 sonoma:         "92398885678dad5a5893f718bfc89a54fa9167ab3cff896ab6526efda0c45e07"
    sha256 cellar: :any,                 ventura:        "92398885678dad5a5893f718bfc89a54fa9167ab3cff896ab6526efda0c45e07"
    sha256 cellar: :any,                 monterey:       "92398885678dad5a5893f718bfc89a54fa9167ab3cff896ab6526efda0c45e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c77713ab82287ec90fe4c060bef509ac1a94c76c66564a48ac153aa7c83ae50"
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
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end