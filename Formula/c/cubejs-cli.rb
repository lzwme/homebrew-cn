class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.48.tgz"
  sha256 "62af21282834fcdcb109885e00c43967fedc3aa896f9403a2631973ac26f50df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b3c07a4c10442e077f2992571d034b402a2140960f2947a48bf003c2a75961f"
    sha256 cellar: :any,                 arm64_sonoma:  "6b3c07a4c10442e077f2992571d034b402a2140960f2947a48bf003c2a75961f"
    sha256 cellar: :any,                 arm64_ventura: "6b3c07a4c10442e077f2992571d034b402a2140960f2947a48bf003c2a75961f"
    sha256 cellar: :any,                 sonoma:        "533ab3478b24ce0dca9a1f91f0bd45f30e4ac8c787665f05e8e2360f9205d877"
    sha256 cellar: :any,                 ventura:       "533ab3478b24ce0dca9a1f91f0bd45f30e4ac8c787665f05e8e2360f9205d877"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5576aff56f3c0bb1c8e01915afb341340bfe367a4219ec0e8997a1130343f39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1baedc6c8c9af8bcb91ea5399dfe5356cb8e420693b6b1a3e5c878e9fe59399f"
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