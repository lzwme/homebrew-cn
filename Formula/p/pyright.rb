class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.389.tgz"
  sha256 "567ddfa65cb5a43a9286c2398b7fdd8755ca0238d7a35c45081d08a7d17773a2"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a820d2b19f044813dfb33162c78ba323fd7df72013d3aac971156e7d90a82f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a820d2b19f044813dfb33162c78ba323fd7df72013d3aac971156e7d90a82f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a820d2b19f044813dfb33162c78ba323fd7df72013d3aac971156e7d90a82f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aa42d7651cb7d7a6849a93881d3266bb45c33362019d87e8c38445bb62bf184"
    sha256 cellar: :any_skip_relocation, ventura:       "7aa42d7651cb7d7a6849a93881d3266bb45c33362019d87e8c38445bb62bf184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a820d2b19f044813dfb33162c78ba323fd7df72013d3aac971156e7d90a82f7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end