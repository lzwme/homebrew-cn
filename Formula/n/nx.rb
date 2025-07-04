class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.2.2.tgz"
  sha256 "985d5b1141f26936f5f9fda6e2042726e84308a46c90129f8bf38554118210a2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ae0c81282868b5b3867aaa97c1162eaa11a8c313d9481ef978398f65ab673e63"
    sha256 cellar: :any,                 arm64_sonoma:  "ae0c81282868b5b3867aaa97c1162eaa11a8c313d9481ef978398f65ab673e63"
    sha256 cellar: :any,                 arm64_ventura: "ae0c81282868b5b3867aaa97c1162eaa11a8c313d9481ef978398f65ab673e63"
    sha256 cellar: :any,                 sonoma:        "4c6c8b7899c1dac4eab6b31f290c89f5b680fb011e8e59d185d34d9689dafbb7"
    sha256 cellar: :any,                 ventura:       "4c6c8b7899c1dac4eab6b31f290c89f5b680fb011e8e59d185d34d9689dafbb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56a21c90be6256e14a0ac15928757a72248f3daa5dd92b6f90e0bbe836d19157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3329b0943ffa4dc4c2e8a218be17f81f72ff326c5619d36d1f9c6919c4385553"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end