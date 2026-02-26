class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "44875f97601613c3e896b6fff36cdadefa7b37f5abb92f9f6e72f7715bcf1457"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ec499da046605a7311655b642b62b312e605d3f24ac6f4eb1e28bfc0ffac1af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec499da046605a7311655b642b62b312e605d3f24ac6f4eb1e28bfc0ffac1af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec499da046605a7311655b642b62b312e605d3f24ac6f4eb1e28bfc0ffac1af"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcf897a42fef296bd92eb7b569e3ca744b4b1c2d4d78f2db22a0732c368ff4ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47b34ec6a61e9ff3a013c92b03f84ac2c0f8e69332f7020fa5b52ec4d45d6e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ff1884bc58e63bee22a795fff807d479914075226b188e303acf38c7077997"
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