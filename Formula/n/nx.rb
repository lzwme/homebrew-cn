class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.0.1.tgz"
  sha256 "40a6b115338eff218b558e5f1a789e335508e90eeb1496fca654c033e458b35d"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e01475ba55620cb6436ba6ae00db9f5aecdaf8dc69211e252e1be024819b330"
    sha256 cellar: :any,                 arm64_sequoia: "467dcc4944b72c93f0f245b17fbe22f95914ef1d77e49342c30a9e9eaa7a947d"
    sha256 cellar: :any,                 arm64_sonoma:  "467dcc4944b72c93f0f245b17fbe22f95914ef1d77e49342c30a9e9eaa7a947d"
    sha256 cellar: :any,                 sonoma:        "b6ef77b694ba0bea3538dbff46ead8b11ef79900a86dd4fa9649e79b9a902aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a03cbc0b29b2bbfe3613ccd99b1835d794d27d2af14f194aad5e3dc90564937c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb2d98d8f07b1165f727e197bf2753f552a91f36de9249e8ac55379e39b00dcd"
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