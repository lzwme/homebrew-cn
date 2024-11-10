class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.11.1.tar.gz"
  sha256 "b7ea6d0ea675d0f968a3bb0aa7cf2196fa6b5089edc1068e28aa4991bce64002"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17b8e54ae88b9bde078dee8df96b1f554afaf106ad7cbf5db16f3aff1b8581a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee9ae1750dbc31d712e78202c93369e733bd1d7e6d8427a3860ce245c23e8a4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "553c269e8d7136a79ba79cd9b953fc9a9cb296ff259f1a5307ef69f5be846687"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e7a9f96d7438cbaa9fbdc4dd8b4fd2cf1314965e6723dd47f89210ff98d1c50"
    sha256 cellar: :any_skip_relocation, ventura:       "38341c42384f6e1a7aa7e2fbe4bd48c03042a9d80414d1cfdf984ea84b4f561b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05a86da07b8f3ae0c7941dc9a3630fce4d768a0e29a46b7b4b3c2e32c6d3c436"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end