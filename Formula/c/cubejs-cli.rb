class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.61.tgz"
  sha256 "1c5e1e827fdc850a4028bae03871e0b7c5c764388a23613cbd209986be859566"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "98753afde38ebd77137d4ae4cb18ca64661a775db8cf601029fd539fa4b3acab"
    sha256 cellar: :any,                 arm64_sonoma:  "98753afde38ebd77137d4ae4cb18ca64661a775db8cf601029fd539fa4b3acab"
    sha256 cellar: :any,                 arm64_ventura: "98753afde38ebd77137d4ae4cb18ca64661a775db8cf601029fd539fa4b3acab"
    sha256 cellar: :any,                 sonoma:        "85181276ff553e70ec579e4d2902b899bd6294a28a51c3066e1689bb426566bd"
    sha256 cellar: :any,                 ventura:       "85181276ff553e70ec579e4d2902b899bd6294a28a51c3066e1689bb426566bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d896c48e1a37871a5f756b58126322b2dad28f273ff885521e24b8820a75fbda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7524e7c7325ae21c6a8273c96eae4ee4edd5fac1f15093911b15d39bf2056251"
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