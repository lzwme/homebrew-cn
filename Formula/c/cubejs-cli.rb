class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.11.tgz"
  sha256 "7641ca7a56ca45c9c942dee823676dddff84efe350915c0448a13c9b80d6ca08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f785d0cc72accde0fb12cf54b64f1ad259560abccc2c33fa5a99a8e45f7cf9d8"
    sha256 cellar: :any,                 arm64_sonoma:  "f785d0cc72accde0fb12cf54b64f1ad259560abccc2c33fa5a99a8e45f7cf9d8"
    sha256 cellar: :any,                 arm64_ventura: "f785d0cc72accde0fb12cf54b64f1ad259560abccc2c33fa5a99a8e45f7cf9d8"
    sha256 cellar: :any,                 sonoma:        "f096bc40c3c3e1db28b59d93a9302a309c8aa7cdde6364883ac640144ecdd107"
    sha256 cellar: :any,                 ventura:       "f096bc40c3c3e1db28b59d93a9302a309c8aa7cdde6364883ac640144ecdd107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a824e24e1efe3b81bc263e2ba715963da2847622c316664bee9b618a34eda4e"
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