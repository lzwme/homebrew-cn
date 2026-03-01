class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://ghfast.top/https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "fa25ed15becb24f29d9ebf1e0a750fa236c81d429e06cf2fc8bc66620491642a"
  license "Apache-2.0"
  head "https://github.com/jonas-grgt/ktea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07540d7089615eeb3f97bf0eb989890a6efbfe56d8d87833cdd12d2e8d94c7f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07540d7089615eeb3f97bf0eb989890a6efbfe56d8d87833cdd12d2e8d94c7f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07540d7089615eeb3f97bf0eb989890a6efbfe56d8d87833cdd12d2e8d94c7f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "20f1492aae675fab6dbb95f711b06ba088555e946cb56dd4cfb4448b2760af3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab24d442f899462eecdaf9a6c06827cd0c2e0ea7be61c5cb7455d46a0a948b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "424f5760e4440f45cde15e14c1414b53fd4943f6ad24aba63fe98dfd2ac3a3e8"
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