class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.0.4.tgz"
  sha256 "dd1bf64358661a2d14dd027f8b0c6d8eea051afff4ec8206407bdb9335991f9f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1d5a9df1f46bf4e9216cd2d88153a9b32a6263fbbb6f700898792a28ad0cb28"
    sha256 cellar: :any,                 arm64_sonoma:  "c1d5a9df1f46bf4e9216cd2d88153a9b32a6263fbbb6f700898792a28ad0cb28"
    sha256 cellar: :any,                 arm64_ventura: "c1d5a9df1f46bf4e9216cd2d88153a9b32a6263fbbb6f700898792a28ad0cb28"
    sha256 cellar: :any,                 sonoma:        "aaf2aab4c5272fbcdfbc4f09a8b5c85155319c34c4ea541a3bccbe372dd91743"
    sha256 cellar: :any,                 ventura:       "aaf2aab4c5272fbcdfbc4f09a8b5c85155319c34c4ea541a3bccbe372dd91743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a363a3395436db3f2721fcc40315d7c50a79ebeaaa480613df61ff7d77b04450"
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