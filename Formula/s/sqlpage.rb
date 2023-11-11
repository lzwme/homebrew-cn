class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "5645457eed3db84e59169189f585a2be937fff1ddbf46ca6dcc3335645302499"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da68f987526a956ec048cbe05e1166d9f6f50e407b6ca04b9d316f7e66c120a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "988768d728497d9b11e13cdfd094cba6104a5191f3d208441b71b4e4fc85df74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efc7ea0f548bd3c94f802ce2fbad3a5e817435b8ceb4b3e2a9d603078fb5f95e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2828e39010af7bf7ba07070e7506b7bb725e142df3f668c845cb580d43f6e297"
    sha256 cellar: :any_skip_relocation, ventura:        "d12f96f3dd306f6803034f30b91477402575946218cfbe5e02fa621b056e3342"
    sha256 cellar: :any_skip_relocation, monterey:       "3ebe8c3cd1aa849449c052757bf539361b413eadbdaa4d6f365de4e66cc9d7dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09ecd84bc5ebc280bdb54fd43840ab64ad2a4c0aefd8b42b82b1fff41b0b52ea"
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
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end