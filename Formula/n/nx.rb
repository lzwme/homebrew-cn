class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.6.1.tgz"
  sha256 "e1a32d9ba9422d03f5b51268262a8a947537cefdf83c2579b3dd593c3b6ccfb9"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b2f86370aea53c582e488e818e3ccd2aaf0b5528eede3ee8b1f8db897697095"
    sha256 cellar: :any,                 arm64_sequoia: "2c46fc64d3ccaa526384ef8844f0652bfc9d8093e43d0020b4fa594149394e30"
    sha256 cellar: :any,                 arm64_sonoma:  "2c46fc64d3ccaa526384ef8844f0652bfc9d8093e43d0020b4fa594149394e30"
    sha256 cellar: :any,                 sonoma:        "14c6d74a468a8c68b50fed879733e619a086e6f0609a3d0a27321a344d073bb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c48d7bf3e4f73bf19e4586d1d6a66f358a4b0d9e5f5abf4212e9c87209b30310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9194cd7c2911cfb2c6f442fb32f0c2cab717a1686ecae9dacff0d359ef104526"
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