class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.6.3.tgz"
  sha256 "5c189e64e48a03da3de1a9a0ac0a90748a3ff7a8df9d2556cee094946d8376ec"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95de7d05136ba5d3e879e411d590b0c910c9ad25163b57608c840c21973852a9"
    sha256 cellar: :any,                 arm64_sequoia: "90934aba12a3b0fdd6436336554bce6f4b02e78dd76556b5fb85a289eb601e5a"
    sha256 cellar: :any,                 arm64_sonoma:  "90934aba12a3b0fdd6436336554bce6f4b02e78dd76556b5fb85a289eb601e5a"
    sha256 cellar: :any,                 sonoma:        "b519b360846bbf8d55b9f6dcf68fe1bf8b0951e58b7bea24d56fe1b25cf45a06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33973d29a3e002e4950da22d8b08b3001e410a3a2083bc2dc179df522bdbfdc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7471be36b04d7ac43ffeac1acc0270451670571777b91c92d13732c80d31941"
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

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end