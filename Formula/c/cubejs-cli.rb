class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.57.tgz"
  sha256 "2e872d8a8acbbb219f29aca5bfc7e49c90e16ffa70e199d0a493699f47225086"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09b7f72535e59d80488456d0f8c68dd30fc1c1fac40b1f9604a86f8cf9169ca8"
    sha256 cellar: :any,                 arm64_sonoma:  "09b7f72535e59d80488456d0f8c68dd30fc1c1fac40b1f9604a86f8cf9169ca8"
    sha256 cellar: :any,                 arm64_ventura: "09b7f72535e59d80488456d0f8c68dd30fc1c1fac40b1f9604a86f8cf9169ca8"
    sha256 cellar: :any,                 sonoma:        "ee7c3d009305bd5a8b929402d6b6ebbb9bcfdbae50824ca103de9400f4416974"
    sha256 cellar: :any,                 ventura:       "ee7c3d009305bd5a8b929402d6b6ebbb9bcfdbae50824ca103de9400f4416974"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68c3a819078f180c78bf56d57208a4dfabf0fb4c620c2d50081099bfcbd21f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490ce8e91de59ea2da726dd3f5df97ce9f7205c48873410eab56d9178328ce44"
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