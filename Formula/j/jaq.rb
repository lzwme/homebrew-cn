class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https:github.com01mf02jaq"
  url "https:github.com01mf02jaqarchiverefstagsv2.0.0.tar.gz"
  sha256 "7535387562c0e5519811bfd1f405eb8cb7683533781e0790981221e8e5b723c2"
  license "MIT"
  head "https:github.com01mf02jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9e1baf5e28388f988404f30cd8fdedffa9a830fcb12036b6ba2517449e4005a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a445f6961b926c0256a793930f1b0bc609ea2abfc162b3fbb9e9a9459c8e39dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da6254ea0bef9c88a10b0e5b2da9c67156cb92f93cfe6ddb793dbd8f225587cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "90d9c16da4895f7983bac9e95204e85032eca0cf9f72872e246cebb8184424cd"
    sha256 cellar: :any_skip_relocation, ventura:       "3b77caeb4a7adbd2a5b99eed2698b7c35897b997d9280f2509eb610f76beb96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a338b6b76bb2fd8ae00d2c6432807ce0578a9ee91db8d058bb95b3c3f693fac"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}jaq -s 'add  length'")
  end
end