class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://ghfast.top/https://github.com/PRQL/prql/archive/refs/tags/0.13.5.tar.gz"
  sha256 "487c710f8b810bb8457ffab944f62930791f23e5ddb25f2bf3257001f07ae0eb"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90cc0f8f16e826bcb862dab23ce8397df0dccffaf04ce3077fb42001268f52f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0914b835158ea4de36dcc7930c1788d5bd04ab440842e2d33f7f093829cb4ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "993ca55eaa2fe3c6dc0dbb60b71d16fa7040b1f4684fead5f740ab65c21e2368"
    sha256 cellar: :any_skip_relocation, sonoma:        "53b391538071c3244c11c2b16bc07332fd5ee88347ec9a4e7f7c21dbad617fb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05131860e1358ebc44504e22941cab5643e679f83f5aa4b5aaa02edd3e0852ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63536778c996264fbcc871b1c91232aa767f2d9b7de39815ff3a29c18d8db025"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")

    generate_completions_from_executable(bin/"prqlc", "shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prqlc --version")

    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end