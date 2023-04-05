class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://ghproxy.com/https://github.com/prql/prql/archive/refs/tags/0.7.1.tar.gz"
  sha256 "ac19dc6fb942a727d0a66c28711a8f77cd3905549737e1f60848525901e7d5b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d2b476ed84f18569745c72e031617c79b72aa353cf2b00a95e8b7ee76e46e67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9802f052ed9d0ff12ce16f0957a9e643eb86a6b8aeed3e28a29ae5dff2a686c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9daf752dd8b9cc1d2973794299fec637dba82d4fd7eddbc49a2582e20e07605f"
    sha256 cellar: :any_skip_relocation, ventura:        "498d98270190f48be1b485be9e985ea72535bb1ca713c17d3599ad79b194ec07"
    sha256 cellar: :any_skip_relocation, monterey:       "ca042041fec47084899ac6a98c4bbbca9c0664a88e0cd24187eaf0bfc3e718f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc0661736cb13ea79aa85dd34a18aa75d8b78a1b55040bf096c216c25b16000b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bc4c92b6060519d0c176ed1aed5966175a68365b6237b4debd4924008c1ceb6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prql-compiler/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end