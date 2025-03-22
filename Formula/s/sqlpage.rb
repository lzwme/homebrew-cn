class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https:sql-page.com"
  url "https:github.comsqlpageSQLpagearchiverefstagsv0.33.1.tar.gz"
  sha256 "b41f289292e528b1d72dff0efbca10bbc8238a0496dd9d60dd566ce190359fcb"
  license "MIT"
  head "https:github.comsqlpageSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5b277e32a10b8b0f5e01eeb2385c2c7863f9bda8910bf4349b286e5aef3f703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34f61bfc9655cb6573a8cd7fe26a9dce907b74936df213cda5dbfbb55a096a56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1a36d0fe75c46a5ed8333067be544dd0013e1b2fca07be69dc0eccc13221407"
    sha256 cellar: :any_skip_relocation, sonoma:        "432b1aed1bf0ec9c553e3df05a31e5306465fae89656fe9e6a0c0753107df613"
    sha256 cellar: :any_skip_relocation, ventura:       "e82e68b7b7a84a8ab38e62460114730e0a850b51445200287c68fc9c78418ece"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a06a8ac838c71c51d811858c2d807a5ae586037493c55cb1cae9156d34051f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32fb9b725a76631fd85f2b341a7abc170d626798ed3522dcbf00c65be62fa220"
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