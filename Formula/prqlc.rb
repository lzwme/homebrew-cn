class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://ghproxy.com/https://github.com/PRQL/prql/archive/refs/tags/0.9.0.tar.gz"
  sha256 "0e0c4370590977e20c18c0c67237e4bcc781214dd54cdfe2ded84a9419b4cc11"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ee12bf55830bdcdd032633aa27d4e5945aec772fc5e61dc6c63a849612a2f74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b5e1bd358775887648358078c93539521f04d0b16b0cfdc1d471fcbdf74883b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e65dc352763e9aa95136ce30944014d44b1b6984c99a03745de3cb386717d550"
    sha256 cellar: :any_skip_relocation, ventura:        "d4db36f209859ec9c86c1f9ff7f9255690e258fc6865cd76af1eebbdb468466a"
    sha256 cellar: :any_skip_relocation, monterey:       "d5746d078dbc1343f697d50bd6cf3448a0d0839659a9bb69f174d3ec1e0a47f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "eac5b9c7f5646639b1f1c2803840aebc0136af3b74cc8b6f7a2e47a18ebdb842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f626c188c63b3ecfb0a17b29dddeb55b4297aa28fafbf2b3305bc8ececa70ae1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "crates/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end