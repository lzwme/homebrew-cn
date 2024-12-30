class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https:sql-page.com"
  url "https:github.comsqlpageSQLpagearchiverefstagsv0.32.0.tar.gz"
  sha256 "a9cd1989a73f9ba8fccbc88e6ed5a572cdff388d3bf768a316ced66fa3b9b564"
  license "MIT"
  head "https:github.comsqlpageSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5685553f3e8b6f185c9ef25d29f326b33f7ff7c2a1f742a09fcaf717436cd6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86cd2210a08cea86cae332210aca92ff727884fce393f4ccfe4f90fc74091a59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b61d523ef8ba17316fc313ee37f0fcded7589c715c13d92ab03f4d058bfa58b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "52fe5f43550753bff967fb0a356bd1e108d06fd94e44f15d66ba96e71c418311"
    sha256 cellar: :any_skip_relocation, ventura:       "2204f331eff43e51fefccb26082da17dc99eaf90fec5ff89a5dea5b8810f21e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc60ebd344c6d7d285f01c9b984ee472d58c300098e01379c0c9a2de28a28046"
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