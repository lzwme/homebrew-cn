class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "1e748083da70ddb02a6e46353cf7e9a6aa009e89a79cefc7ffc748db0339e266"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78991402373b737945f57155ae9c98d35281316100ee67e23aeef08248793a15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce65f1254086fba5151c522419f65598fd9c2e93c85275abd6ec8e10fd4cc562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9bbeb6fdfd49e8a2af8764ae88c0e265ae42aadfbf670b5c414b65a6b6a59c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "08ad7b817e11641c61e12d1039d326e30881d79b3bcfa5294e299929f5ba29b5"
    sha256 cellar: :any,                 arm64_linux:   "e15c00497f8b290fbf23b31e17673e19f8145dba46d1cc3578b78ed3bacd8b1b"
    sha256 cellar: :any,                 x86_64_linux:  "4a9a0ea5447a7915c6b9d48cbcbc5700ef5c8aabdf7275bbd4ce3ac42aa206ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end