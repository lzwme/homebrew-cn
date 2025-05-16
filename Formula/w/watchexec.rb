class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https:watchexec.github.io"
  url "https:github.comwatchexecwatchexecarchiverefstagsv2.3.1.tar.gz"
  sha256 "b4d8199ad4f697a43122769b321ecd52a9020bfe21e5cb960a857ef2734ef86a"
  license "Apache-2.0"
  head "https:github.comwatchexecwatchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:cli[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c360742a453bd67041b9232ef195da53a9434ca201f6123f4fb9290e5b112777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b67b36bf2fea573750c416d4ade109acc00e8a5cf9a3b90dca0a94fd81c30cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41f9f551acc5bc9aa23f6d9edc5f79d05c00fad08f33b8c695beb1d0f891053f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d3fa058f57d7ff136a951c742b47be4cdb469a26ccac1397e3b0f203c53582"
    sha256 cellar: :any_skip_relocation, ventura:       "c5e2574346a581b7cc5274979c3acc71f063aa9d5f0d43cbe87c87266eda51e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e110f3effb551fdab477f68f6eba3d35aafb99e0e7bb9dc10cc9ca197f37965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650e64ccd5814aec58ce2556fbf5fcde0e1da8672039a5530c5b1fc80948e464"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"watchexec", "--completions")
    man1.install "docwatchexec.1"
  end

  test do
    o = IO.popen("#{bin}watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}watchexec --version")
  end
end