require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.64.tgz"
  sha256 "ad60e9fb760326e7b8f2a4c5884f21b9dc1b0bbcd9d8238825f92e55ad8ce98c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6052d216c0164a5e5ee044dcbde8a13fc7f7132bb7c229b22964078853ecb9de"
    sha256 cellar: :any,                 arm64_ventura:  "6052d216c0164a5e5ee044dcbde8a13fc7f7132bb7c229b22964078853ecb9de"
    sha256 cellar: :any,                 arm64_monterey: "6052d216c0164a5e5ee044dcbde8a13fc7f7132bb7c229b22964078853ecb9de"
    sha256 cellar: :any,                 sonoma:         "8f757f29ad19870cbffe9e7e3e13979195c199fb27d90655a97ab02129a28e8f"
    sha256 cellar: :any,                 ventura:        "8f757f29ad19870cbffe9e7e3e13979195c199fb27d90655a97ab02129a28e8f"
    sha256 cellar: :any,                 monterey:       "c6da46331674eb54632dfcdbf56a54a766304344fbb8da20a241f8c31f8b6ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b047db4bdb1ca8684124809d5692b33e87584ad83f4d5db85d21288eaac666c0"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end