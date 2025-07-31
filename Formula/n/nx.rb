class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.10.tgz"
  sha256 "2a9d0df0539d9819dd2630a3ff27e2e42ad6e96cb4eefa7b1b1c4201e28a02f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a2ab0f39127a00066780345265048a1e34a8a2571c5bc6a3f40c96c7ee49ec36"
    sha256 cellar: :any,                 arm64_sonoma:  "a2ab0f39127a00066780345265048a1e34a8a2571c5bc6a3f40c96c7ee49ec36"
    sha256 cellar: :any,                 arm64_ventura: "a2ab0f39127a00066780345265048a1e34a8a2571c5bc6a3f40c96c7ee49ec36"
    sha256 cellar: :any,                 sonoma:        "c2d8f1860030055580eb357986ddd95d01e84a32497a96eb0e54b8e8216a6dcb"
    sha256 cellar: :any,                 ventura:       "c2d8f1860030055580eb357986ddd95d01e84a32497a96eb0e54b8e8216a6dcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc98abfc1fd3329931d90480a75c2bc814fc2d7150983818713715912c6a7e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea7c79a53cfe4d3da24ab0bec09109c6e9707cb0df3e7f314ad75121c46fd7f"
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