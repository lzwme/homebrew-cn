class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.30.0.tar.gz"
  sha256 "abc0e3d39d733d4f4c811346d243ff42bb139519f852f8d71dc9090d6d7f56b0"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2accff43c8d2ec499de41be8b7be4b2cfd0628d2b7b17be0cd7ab09a01470138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58bce1e11b1ee0543dbbb9e214b0640b6a19e3d50f3e32787d58019b4d0cccf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f750ed3559fa892a93aa3983b78a2e445e1874ca79fae177231a1511b85c68f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1a426ded93a6274a7a91d4418e9aaa3e93603415bb1c9f6683f88fe7c599a82"
    sha256 cellar: :any_skip_relocation, ventura:       "ef76467bf207a52524e7a14d01df5c2b374b78cd8177631ec35468b2f1b22322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72a9ce2116fe3807b13b0be43adc49b780179c4fae6d824632dd04aeb115694f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http:localhost:#{port}")
    Process.kill(9, pid)
  end
end