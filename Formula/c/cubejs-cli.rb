class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.1.tgz"
  sha256 "a8c3d96f7e22c88d58a12474afe6841da9b68ff9bc2a1112eeec56cf64fc014b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "daa289e96a461fe8e8fdc6b702ae7fe227aaff126c2f841b74e6b73a74d81a11"
    sha256 cellar: :any,                 arm64_sonoma:  "daa289e96a461fe8e8fdc6b702ae7fe227aaff126c2f841b74e6b73a74d81a11"
    sha256 cellar: :any,                 arm64_ventura: "daa289e96a461fe8e8fdc6b702ae7fe227aaff126c2f841b74e6b73a74d81a11"
    sha256 cellar: :any,                 sonoma:        "53c0558a0989aedbed7e932109249ddc4c8d9ef479a52ba42581d67f9899b3a3"
    sha256 cellar: :any,                 ventura:       "53c0558a0989aedbed7e932109249ddc4c8d9ef479a52ba42581d67f9899b3a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "643731db8ae85a6240f4137c6e8f5dd7a5223889cc279d37c0ddd0d9402f409d"
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