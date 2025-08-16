class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.4.0.tgz"
  sha256 "b06df88fff64535b209b3787d370cf7b5ddf33e09d6616aa1127dc9f67b6dc2c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9a8581e3c5a21d2949cad5245d788828fc458509a1493ebba1ce604217c953b"
    sha256 cellar: :any,                 arm64_sonoma:  "f9a8581e3c5a21d2949cad5245d788828fc458509a1493ebba1ce604217c953b"
    sha256 cellar: :any,                 arm64_ventura: "f9a8581e3c5a21d2949cad5245d788828fc458509a1493ebba1ce604217c953b"
    sha256 cellar: :any,                 sonoma:        "c76ab0366cf0c730e36d4b416f2e9ae2afed1fe0d266e149d22d1094aec675c5"
    sha256 cellar: :any,                 ventura:       "c76ab0366cf0c730e36d4b416f2e9ae2afed1fe0d266e149d22d1094aec675c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "246a23fb6bab7719663277130b0a968afb98624d74f2415a307816a34c8c770c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08daa965f30fa8399a90682c6021fc04387e184c83ac4c13fda8b07b8ff60ce7"
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