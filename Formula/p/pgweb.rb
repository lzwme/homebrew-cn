class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https:sosedoff.github.iopgweb"
  url "https:github.comsosedoffpgwebarchiverefstagsv0.14.2.tar.gz"
  sha256 "58c1268b8fd08513fb818ceb8bb1de82715e88978f27a7a33e7f1689fec4c868"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec8dfd03b6f3b6b0d95c8868fddfbbe0841554133343fc293428bf0ebbb0e993"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aa300ef40d8cdd85697b3cb5b2c6e9c07cd5231b3e812e899dbdfec4f77cb8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5015d53add1c6a615649c1c5dea87df25969bcdd8ea1b59d7af780cb1f6e9b7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4549aa5f8de87cca67c7354c210bdcd2e0f54f5cf3fb6e7626163ad4b4ac8b22"
    sha256 cellar: :any_skip_relocation, ventura:        "06c2957ecf2dd17776979a200e55c7a9fbfc8f4bfd5862b9e127990c87cc540b"
    sha256 cellar: :any_skip_relocation, monterey:       "c3b03a8a0e75b3097692dc07e1d2fdb7272772d63f0cefed893ea9ce542e16d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eac8b536a2dcd186c1938d319aae4414c5dd63f15372e2912ed1eb100dbf571c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comsosedoffpgwebpkgcommand.BuildTime=#{time.iso8601}
      -X github.comsosedoffpgwebpkgcommand.GoVersion=#{Formula["go"].version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin"pgweb", "--listen=#{port}",
                          "--skip-open",
                          "--sessions"
      end
      sleep 2
      assert_match "\"version\":\"#{version}\"", shell_output("curl http:localhost:#{port}apiinfo")
    ensure
      Process.kill("TERM", pid)
    end
  end
end