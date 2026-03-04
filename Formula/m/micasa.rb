class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "c58ed77c70db1eaacee646af6d22400991cf78be4988dfe5215b2785fef9da8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35639236c0aae79c90936aba183cbce0d94e7c19a0e4a6121220751462ef7595"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35639236c0aae79c90936aba183cbce0d94e7c19a0e4a6121220751462ef7595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35639236c0aae79c90936aba183cbce0d94e7c19a0e4a6121220751462ef7595"
    sha256 cellar: :any_skip_relocation, sonoma:        "960d10235dc9f19863a1b480474907fea82fff6cc06927f4f0ea44cda583f167"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61a3b93f28d2e67ba177e3ead2a7e7b3f78f52f8f26ee40eefbf1e537a53f07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d242c9194bdaded296105ac65bb34c9c9245da7fb63b6531ab03f96ef21345a"
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