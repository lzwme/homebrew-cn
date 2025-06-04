class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.1.2.tgz"
  sha256 "f0c866819641ac6aebf96a3370cfe726f97016c749db1f530c66dda0abd61ed7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "64826a6e28d4d5717bda79628fbfbfa39c708aea0e337752d889b88b5d727a47"
    sha256 cellar: :any,                 arm64_sonoma:  "64826a6e28d4d5717bda79628fbfbfa39c708aea0e337752d889b88b5d727a47"
    sha256 cellar: :any,                 arm64_ventura: "64826a6e28d4d5717bda79628fbfbfa39c708aea0e337752d889b88b5d727a47"
    sha256 cellar: :any,                 sonoma:        "62ec9edb941f52075abde7d51323b1f6b720bf2573ed3819ff15e2e6f3213544"
    sha256 cellar: :any,                 ventura:       "62ec9edb941f52075abde7d51323b1f6b720bf2573ed3819ff15e2e6f3213544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "565d28ed59e23306f557eb4406ef7040999e45f1fe911281e5355a5fb4fd089b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebd4cba813beec1ec8525be1b6e69a98b612b0a045a5fa2ca29a69794f8b1b8c"
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