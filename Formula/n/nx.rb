class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.2.1.tgz"
  sha256 "7cc166598e3db963c12d4e13a0fb374a8f6d851a1c843c0f72ef75df3258d960"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b3ecebbd20d60a13f15e4430ae452ad5600791c98135d6b0e9ba53629d5dbf6"
    sha256 cellar: :any,                 arm64_sequoia: "b1e5c20e2d16d651683ecce1b310194df7e192edf274abea8512e8a30d32ea7b"
    sha256 cellar: :any,                 arm64_sonoma:  "b1e5c20e2d16d651683ecce1b310194df7e192edf274abea8512e8a30d32ea7b"
    sha256 cellar: :any,                 sonoma:        "bf1555e0d6ed25afc07a5e53b4a00d9e0fed5b87c71b634b8f7dc75fa3b6ecf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cb0ca8a47c7e1558f7e270e64e0cb99ab117b71578394a50967c6d452176116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7c0b9eae5cbaac21cda1c6988fb5c67368dd024fa49535f182791508189e0e"
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