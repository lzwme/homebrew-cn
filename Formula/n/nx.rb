class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.4.1.tgz"
  sha256 "8df3c7f49911bbc7790c9f05cb7a1ede6fb2fe9165be667944c00f69c1e62c56"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "653c59d4f376a649f55d7f3265e34a54f8ec2fbbcbf8dbfffbacecfc31419147"
    sha256 cellar: :any,                 arm64_sequoia: "59da0c7aceb47d7858697a463ef805d50490454f8de0d43e05e4e741093c0d41"
    sha256 cellar: :any,                 arm64_sonoma:  "59da0c7aceb47d7858697a463ef805d50490454f8de0d43e05e4e741093c0d41"
    sha256 cellar: :any,                 sonoma:        "55c0f24371570558d2d062071f37e212b6c03b1bfb426fe698e944051cf83380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c008df187202518e0c192990fdd63f26e615c1eafb644378bb66a8e4ea4f010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "039fb3587b4de25be8d9d844525389bf6dbf73581e3e50731cd85ffc9654cb3a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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