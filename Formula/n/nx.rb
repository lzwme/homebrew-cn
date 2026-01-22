class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.4.0.tgz"
  sha256 "0ba0f36d65dd9ebb371407c6df0281007fcfe74d4e9d5225c538261a1e545dd2"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c4368387e5bccca69ab6984b4816ed5b223db54747228533b126745ba52d53c"
    sha256 cellar: :any,                 arm64_sequoia: "7bf006795bbf2dc9069fd526afb53517e839083e7888230b4e26e825980ae417"
    sha256 cellar: :any,                 arm64_sonoma:  "7bf006795bbf2dc9069fd526afb53517e839083e7888230b4e26e825980ae417"
    sha256 cellar: :any,                 sonoma:        "967a7029d76e7b5bfc6240caba135f5cef423f57c45f84806b7fe3ed386c1533"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f525c5d23978f4eeef90536a5c3b8d37730d3e1a64071087778239432721e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c719d866f056a6546f182ee27a5bb5c290e72e7ed4d4100129a1e65de1961a"
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