class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.2.0.tgz"
  sha256 "6a36f400625250b167e38713aa57726404dfdd4bc93174b5243ba60f7eaf6954"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "390cbe7612b08879810f64cf387043bdf7c4f62599703881dadc00a80d30b488"
    sha256 cellar: :any,                 arm64_sequoia: "9b771179c595da20f4b90b9b69ab5a87d3979008571ac9315867e0169664f88c"
    sha256 cellar: :any,                 arm64_sonoma:  "9b771179c595da20f4b90b9b69ab5a87d3979008571ac9315867e0169664f88c"
    sha256 cellar: :any,                 sonoma:        "b8e4bae7e19c7f527441212756d66664e58e89ed94cb768ab306776dc630463c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f38be74cf830de714f23e8f1f630941be8034637cb9bb9ed94f2f223d7736b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "369cd24c724151add52f396c2f72326efc1cbb721aa46d9d21bf0446d8848436"
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