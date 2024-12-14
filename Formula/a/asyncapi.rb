class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.13.0.tgz"
  sha256 "e48650795df5d4475706c1e257dec64465c7f5e63693b25ce1d67d56cb65fdc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4bb570f584d5edde6782e9b45bd1c1ec5ce591ad661300792757e911be20a89"
    sha256 cellar: :any,                 arm64_sonoma:  "a4bb570f584d5edde6782e9b45bd1c1ec5ce591ad661300792757e911be20a89"
    sha256 cellar: :any,                 arm64_ventura: "a4bb570f584d5edde6782e9b45bd1c1ec5ce591ad661300792757e911be20a89"
    sha256 cellar: :any,                 sonoma:        "c852ffb0fc1927f59f574b0eb712f26fcda73b563088ffd131f5b6942c55b76e"
    sha256 cellar: :any,                 ventura:       "c852ffb0fc1927f59f574b0eb712f26fcda73b563088ffd131f5b6942c55b76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b5e8d2d9c4c1e3bbfc4a5e16afc966445139387b8d801f8f7644e68abd31f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end