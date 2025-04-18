class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.4.tgz"
  sha256 "024fde0c87825f743bf63de831f8561cd4e6c0a07fb45a40df1e1c60d9eebc7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0cd1ba5b69e5e7b46ff830c28692fe1bbe1312394916a2de05242596e41dfd05"
    sha256 cellar: :any,                 arm64_sonoma:  "0cd1ba5b69e5e7b46ff830c28692fe1bbe1312394916a2de05242596e41dfd05"
    sha256 cellar: :any,                 arm64_ventura: "0cd1ba5b69e5e7b46ff830c28692fe1bbe1312394916a2de05242596e41dfd05"
    sha256 cellar: :any,                 sonoma:        "5d1075a664af986c60a9f9a300e1c640f83bed828f2da693772db0fac07dae2e"
    sha256 cellar: :any,                 ventura:       "5d1075a664af986c60a9f9a300e1c640f83bed828f2da693772db0fac07dae2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63389a1ee642004d1b4af0fe7e4af24b06dbeffd589db80032fc0afd60f56e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8999747b072938d0e3d7167a6bf8b079485a33e9d201d36fdd3c5c2837936ad"
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