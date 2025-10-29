class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.0.2.tgz"
  sha256 "d0d04ed31578db04329eb50f9fd8b263594d4697a9d653e5bb29570142a58b18"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c27b45525049dce8070d8bed34a25871bf28ff214e66ed3a7e7277f89664daad"
    sha256 cellar: :any,                 arm64_sequoia: "2f8d92498d14af7b87db4e4eba4548b80703387953f83b04759c5f6c35f64524"
    sha256 cellar: :any,                 arm64_sonoma:  "2f8d92498d14af7b87db4e4eba4548b80703387953f83b04759c5f6c35f64524"
    sha256 cellar: :any,                 sonoma:        "d0fdb24502c23192f46322635bb841a2e39f1d59df912a7f941ec54644007c56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6e3782fbb302ae4e6bdcb692be76e7113522d9c001103e5c856a04b28381514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b924a01bcaee7279c27c4e1b1016e0935b9105508ae9075ffac47d74f09d45c"
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