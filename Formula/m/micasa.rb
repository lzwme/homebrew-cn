class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "5c33962b3e7670f37ea25606e7f60d672faa2b095868c1d28896731d2805203d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab62206c59ad58bb2c5e397c0125a3ba97d8a8bb92844a150c79fd3380b8c60e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab62206c59ad58bb2c5e397c0125a3ba97d8a8bb92844a150c79fd3380b8c60e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab62206c59ad58bb2c5e397c0125a3ba97d8a8bb92844a150c79fd3380b8c60e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d7db8bb376dc3716a188d75dee3c81cb2d55e94a2162f8dc606685e4373ae54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "510190ddf685b6d7f92f1117f0fbd7b73b53008fa66286af21c778da4bc24af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fab2ffb324ca01ae80043126830151189df19b252ca9142b19fd90ff361adc55"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end