class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.6.4.tgz"
  sha256 "53b6270076b73db1059305c58cda91b65a97845694763dd5435a368e5c872d46"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b5ad5ac65de2bacc36e70b83b07d27809f423e1f12e9b47c0b30737ef6bb986f"
    sha256 cellar: :any,                 arm64_sequoia: "b3c58c8ba87ce2653ca313c31cf856d206845377cc8d8ba2e5f60149ce3c0c59"
    sha256 cellar: :any,                 arm64_sonoma:  "b3c58c8ba87ce2653ca313c31cf856d206845377cc8d8ba2e5f60149ce3c0c59"
    sha256 cellar: :any,                 sonoma:        "b94d465256248e7a9802ce936dcd9d3bbb0dc577efd067f52cfabaf9730727df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e900e08590108e25625ada6029c47585883726e2fa3a67e2dbe3ab025c865f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b25127c99258275519c5f8f8020da5d4f8a9993628a792b4c0e1d939fbbe743a"
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