class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://ghproxy.com/https://github.com/PRQL/prql/archive/refs/tags/0.9.2.tar.gz"
  sha256 "39f3a72667654b4feeb72a832bac506b91a297e2c5e92bbbb552cfb89a20baed"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ad5f18db59be8e1628353b64949ecab1784c525448a66bbd2376971d1b87dff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35e2079c6a5af8069fc918de8585f28ca0ede2801951525891a9aff238759d4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71341b1ffbe77740431438bb6622eb618cc4274c8ab12400661a4a3834b3737e"
    sha256 cellar: :any_skip_relocation, ventura:        "2fc5e84ec0ec2bbd28d6a009b307c9eded4522c05cdd8f472868b2c3886ac018"
    sha256 cellar: :any_skip_relocation, monterey:       "958a17129797f7205a6f0cf3d68df0b52d5d7118dad7174e2aa8e048ce736fad"
    sha256 cellar: :any_skip_relocation, big_sur:        "89576dbd8667e7a8eb96d8e94c11c710f559f5f85a208a0252f9074bbc0f31f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c743d581c5514bee72bee5386c98638e365043100d5c6c5d42db500d28ac1e74"
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