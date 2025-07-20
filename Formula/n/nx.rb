class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.0.tgz"
  sha256 "e6bc0562a194786b2b108b24975403eafc11c180ce5651393b9451b16ecb4bfb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "762275d234b99889a8657251281f3144904c605a4951231c487b03f3a7ad0e35"
    sha256 cellar: :any,                 arm64_sonoma:  "762275d234b99889a8657251281f3144904c605a4951231c487b03f3a7ad0e35"
    sha256 cellar: :any,                 arm64_ventura: "762275d234b99889a8657251281f3144904c605a4951231c487b03f3a7ad0e35"
    sha256 cellar: :any,                 sonoma:        "fcb70457d007dcdeb3e13cbc8684819e154174e151478e646fe0f3103cbd4e85"
    sha256 cellar: :any,                 ventura:       "fcb70457d007dcdeb3e13cbc8684819e154174e151478e646fe0f3103cbd4e85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbce55d9b4be4418a90fa234e000b1fcc8567070bcd9c1ee790f23d100c1bca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac9a0c696ecfaf0483ed4226e5b48649894d6b473cb3616e32658901691b242"
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