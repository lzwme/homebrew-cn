class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.24.0.tar.gz"
  sha256 "101ed09bbb0b1129c8542a42d5e15e96d05971b1b6c6e5f7e9ad3b7d978d03b2"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25309a7806b7b84d77117fcab26fcb3dc064cbd2fe337d3c1af98bdef59d29f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca94ee7511f4db5dc193c48410245d0d66c6a3a88b4691f29c7d342004c415c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c87935eccd31ee7ef1e758ce6afd6a41df143765a2af8fef7b793ec23fa659f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "721e98eff9e02895abf0f628381f71ba39cedfefed4d5ee392b1401d55c85605"
    sha256 cellar: :any_skip_relocation, ventura:        "bd0cfd70b104ec3101c784b5501f9d58605b3a102f344e7d931e515c1679f628"
    sha256 cellar: :any_skip_relocation, monterey:       "1394a65279b77099827c1e3cb45134d47d3e6d4240651c0235d0b2caee87d1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45d0a57f9d0cb4038e4bf28403cbc023dbc5454424cfde2af2c122b744e61336"
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