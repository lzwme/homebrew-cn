class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https:github.compvolokmprocs"
  url "https:github.compvolokmprocsarchiverefstagsv0.7.0.tar.gz"
  sha256 "5e23215885da9afdaa420e24749f4a4ff3b04b0d547dae9e756aaae2748e8b88"
  license "MIT"
  head "https:github.compvolokmprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e389cac5772228409ceb4947c882b0ef3607fbb0d3284a34ce11128262d93e33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dcc5ad18b12653d8a33a9d4b23c3f16ac1b17818f779ffb348a1571b1790a34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fa31bbc13e511fac507b9f128abf7481a8fd0ff749d117fdf6575b9f5b88833"
    sha256 cellar: :any_skip_relocation, sonoma:         "b524ae4791f2d9b553b02564d93791cc897771784b4b683aabf45a5b9a7e36ba"
    sha256 cellar: :any_skip_relocation, ventura:        "a144c711d1b951e1bd3803b4ee1f8931a63b28253fcc958cc1b061f421788d90"
    sha256 cellar: :any_skip_relocation, monterey:       "65e3a738e891225e7b0327739008f295061a7a652aa9911ab904ec539f370a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72bc4af5264a2605a7b29dae77a4462799aee795a000934fa5097c0345358a5c"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "q"
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end