class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.4.2.tgz"
  sha256 "0811930bf853883ad5dd7b4360cb1287197e92d3c3a75c03b56e647d9e1d03cb"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf534671f15a39c9e33ec4e79382fdea5623fd2997dd65da0a0ff91acc7b8476"
    sha256 cellar: :any,                 arm64_sequoia: "e4dc26d8d8f5b603e9a2e514d40f75de4ad4714416ef6aa7a85f469b3e408a2f"
    sha256 cellar: :any,                 arm64_sonoma:  "e4dc26d8d8f5b603e9a2e514d40f75de4ad4714416ef6aa7a85f469b3e408a2f"
    sha256 cellar: :any,                 sonoma:        "c8697099e697f08d1a99a0b84ba9e28c0d442a56b8acecaf21a9b939657658c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37097333ed8ffd449ba2286768f36322cdfb8f9fe437432a9090ebdc372ddf67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2f18fabd964fc3743a606685084e113e45beed2187eac0370d7702ebe29838e"
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