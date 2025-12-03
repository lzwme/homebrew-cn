class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.11.tgz"
  sha256 "a13614a69ef84eec2632cdb0782be06c145c48ab6e402192e351b3212a537a6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb21f1528b4216f791bb78841c4f12bdcad862d919ad0d8ba7858821a3404937"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1c6b18670e19f7440799723a012c5f8a5ba7a16afd17c5a710c01c988b2b983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1c6b18670e19f7440799723a012c5f8a5ba7a16afd17c5a710c01c988b2b983"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae1d2bbb0c39ac0e6a1315f3f1d2b6b5e2e1869970b9bfdc12ca2db84ee74225"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a388f985395c4faf958791d7ebe9ed4f4ef5facf809b399ff9b71cb48822a9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a388f985395c4faf958791d7ebe9ed4f4ef5facf809b399ff9b71cb48822a9d6"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end