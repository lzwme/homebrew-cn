class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "4c33c1c686beb53fa0de06fcba12261fd4d9b2d6d7dbce5a5d06ba823449a0aa"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "813d6fb832bb26f4b7f8a927dbe71342ea7a837bcf8cbc01ac59b30754adb28b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae6b78595cb9f599eae6e8f76b97b338b7653325b1bd59cfec25dfe69ebb99d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b63f04963cbe147fe20f71fb4ed7b5b39bce051318428053ac70a8460c6f10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6faaf0ff4a1c5db2ef0ab8b4700216242d45bfe31a872ba971e94a597a8f2831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9790448ffe6fcd5f6a79c57dfe55a8ef2fd503aaef05da06b55131929c4cf33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0236abfef26adae6bfa161a2d7feadbc1eb4be6716a48c97bcfc14b67a180124"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end