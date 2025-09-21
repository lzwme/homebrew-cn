class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.5.3.tgz"
  sha256 "8ff8c6b59c6800a540515a9465a402b1971d0ed84e6331ee93b226ddb18e6419"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2737c6c433c6a5b07652d38256049c31326eebed57c7b99940f04d2e84471c41"
    sha256 cellar: :any,                 arm64_sequoia: "2de66381171e82a866bc28b7e7d9ae018b9b1c376bd2fe566b701b320a912d3a"
    sha256 cellar: :any,                 arm64_sonoma:  "2de66381171e82a866bc28b7e7d9ae018b9b1c376bd2fe566b701b320a912d3a"
    sha256 cellar: :any,                 sonoma:        "b31866f3b53f5a4742aadb111f81a9a1ffa6b4ad6d2b0166d5da7fd1210b9bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "152c3af26047e02a86426a04f164eed95e3b45a49b7041d4fe191ed2e9d49067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00044603dd955d365abce91ae88bf90ce9400f9326ca91211dfed66be79f114b"
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