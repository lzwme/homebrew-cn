class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.18.1.tar.gz"
  sha256 "055ffff4bd11e0f134b6dead0a56d8253344a531d0a431fd0967986e33fdafa5"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "582ecce059d474cf016060adce3c23df1e604a994673fd87fa30f1a6c9d822f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c486a096136d6457a498bcc67b0402f5529dfa5dcf95e96ba2f8be732432883"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "292830b30b54f0c90421a6258fc884bb32ca076a5c44c16b915e4e0ef1df1720"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0cf5a301a04f35c23849e60961c221135a8c5a7bb0609e0b5a6372748528801"
    sha256 cellar: :any_skip_relocation, ventura:       "c0bda90a8a388e54e0577481f44482aeb6c40a447235a3793dfd9e59348d4345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "575f7f6fd6ee09b2e7fef970ac29cba779cbeb1f02e54d0dd2d5dc8b85c5790f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a538fd2d733716d617fd4b9609346f48c74c7185a0421b2272cb9e96811c014"
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