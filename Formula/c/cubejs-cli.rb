class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.81.tgz"
  sha256 "3d373f7ac874a754f07d23be1d9333c2d87f57e2ccdf34edc9ebf9cf38caae9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9b7a449bcfcd7762e7d41ddbda15af7c319827ba184aac021c4cf65c28961df"
    sha256 cellar: :any,                 arm64_sequoia: "d62309ebf6060a2a390609b31c78da47f037d7fe55b6aa14410025a1ceb58810"
    sha256 cellar: :any,                 arm64_sonoma:  "d62309ebf6060a2a390609b31c78da47f037d7fe55b6aa14410025a1ceb58810"
    sha256 cellar: :any,                 sonoma:        "4dc76bd4825fd4e92f78a642fec371c1cad5a2c55c3f5f9d671bff412c6d57b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "787a96d754360e0889af34aa9ecf37986975922060b8208fae3c52261126c61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e335aa271ceb31105e6403a7a8c35c72f3c23168e8473323c1bfcdd57ac0df65"
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