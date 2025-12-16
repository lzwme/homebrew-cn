class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.2.4.tgz"
  sha256 "6e6e4432cd347ba137f12f6e84748249b207d48bb194c65a30f6d54459d72c52"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "962653c61a44c491140380c1dc66206bcd577a22ae01e098a00d5fc378e46400"
    sha256 cellar: :any,                 arm64_sequoia: "78937f05510732103e9e76014c521f39496d8bb350c86f29d702ba2b1ff3e152"
    sha256 cellar: :any,                 arm64_sonoma:  "78937f05510732103e9e76014c521f39496d8bb350c86f29d702ba2b1ff3e152"
    sha256 cellar: :any,                 sonoma:        "d212873953831e31f4fe55bc2002987eae3d151f80ab9faaba7a7cc3b5a18bdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d5a17d4f64cc1b0002a22f7b3f7c872a77723a68843d78abc3e5ef29fde1b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d4d2d0f3ae6e0b312221641d6c87724e631b634977d658536e2a1b808432d71"
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