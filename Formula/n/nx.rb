class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.4.4.tgz"
  sha256 "3fd64e6d05ee6156ecd4cd476e40f167b4686719c010efc3d590458bc16e56a5"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "83839b3292fa5cc6526ca300a5617b87acec26900178c0b0005f7830b639fc95"
    sha256 cellar: :any,                 arm64_sequoia: "a63d25ce08509f896a01f4fcc8451c0a9bfebcf700a7848d905e89c31c3b08b5"
    sha256 cellar: :any,                 arm64_sonoma:  "a63d25ce08509f896a01f4fcc8451c0a9bfebcf700a7848d905e89c31c3b08b5"
    sha256 cellar: :any,                 sonoma:        "bce611e4f83ba496591f0d276122de49a215d49cfc2da0ee79bd1ded7750f55f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5daf237b5e88773707f7b56015cea21a75b930d4e3ca78d9cbfdd0ff3b44e4e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "557343a813d686554c6b64298f19084fda583f0fe23a9cb459f9132823be4194"
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