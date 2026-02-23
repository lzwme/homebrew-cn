class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://ghfast.top/https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "f6bcee401fcee6a7fa1cea82364cae54832ca9fc76258085330790ac92ee158a"
  license "Apache-2.0"
  head "https://github.com/jonas-grgt/ktea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f80a264b2f3d284a903d4d84a9e8a69ceb276234c2612ee2a2220e001cd58651"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f80a264b2f3d284a903d4d84a9e8a69ceb276234c2612ee2a2220e001cd58651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f80a264b2f3d284a903d4d84a9e8a69ceb276234c2612ee2a2220e001cd58651"
    sha256 cellar: :any_skip_relocation, sonoma:        "41bdade549bfdb588b2f5e628008906c7de69e4b509c69a6bb8cd27419904e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e10a3c9059ad237d3e997a29a47eae25874a60471021069afaa62f51010b23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0817cb2ae89f71835c4e840616f017e23e297858a37b247aa77822fd045c525d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "prd"), "./cmd/ktea"
  end

  test do
    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"ktea", testpath, [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/ktea #{testpath} > #{output_log}").last
    end
    sleep 1
    assert_match "No clusters configured. Please create your first cluster!", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end