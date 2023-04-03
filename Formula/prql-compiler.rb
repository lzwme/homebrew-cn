class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://ghproxy.com/https://github.com/prql/prql/archive/refs/tags/0.7.0.tar.gz"
  sha256 "3585ddb74f23a9dab7222ebb2ba645c9dfb15657123646483cf154b014737bc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ad21f836639f438aee174074e1096d0273374ffce086b5d3bf5bee58d373989"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c78f3df4cd8e06bf488d4d2da0420c8f280bd64b26797d1a7139e8185122ba9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27b382e403be946ee31d92fad4ab102f2edc5cdbcfbe49aa987e1a5e70b33c39"
    sha256 cellar: :any_skip_relocation, ventura:        "b96b885b659ba082ae8e2b7f7f399552de161a891196d0b87a66d0587e9fb669"
    sha256 cellar: :any_skip_relocation, monterey:       "856ddb98b41760f20d60f9e24510881f1d0954e9b6edf3698900b172b400736c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8d610435ee5e2fec9fbae623e0cd0e5c35cb67903679a92408ed51e5a06d899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27d4903b69c87a324faa4ffcb4c325b32c47ae5bd40e2b94b91b8af5e5c4b8a5"
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