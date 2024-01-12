class Dufs < Formula
  desc "Static file server"
  homepage "https:github.comsigodendufs"
  url "https:github.comsigodendufsarchiverefstagsv0.39.0.tar.gz"
  sha256 "4904c7b21feeab97be4ac442ca993293ad9f5cfcafd346bd10ea2c271f2ff5c5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ea21a208a5e02d2e9d84fc4492739d4b25ba087b9cb21565d5fac06306d3770"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df4fba94ae70d9d2aebde1cb1520c15d0abce76fc7b26cd7eaca241f23c51cb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33e56e2292bda4146a64b52ae21e618ad07b5aaafa79edf39f93413a568fb988"
    sha256 cellar: :any_skip_relocation, sonoma:         "05d53edec6bbf7a6e63b6a1ba01f994f686fd7bbe0254409b8eea49d138639e3"
    sha256 cellar: :any_skip_relocation, ventura:        "484b38e034b85c93b9305f6b3235d0ed89b540c71dd85a450c073719df5d75a6"
    sha256 cellar: :any_skip_relocation, monterey:       "0a0eff4fc160ef92785d1af171f082ce3615eea6d77677143b89e34e9fe835b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9519edb9f6bb8c2ee6b8d57a43bfd185a90c663300aa2336f87a137fb1f13f44"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"dufs", "--completions")
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}dufs", bin.to_s, "-b", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin"dufs").read
      assert_equal read, shell_output("curl localhost:#{port}dufs")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end