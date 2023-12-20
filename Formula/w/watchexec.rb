class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https:github.comwatchexecwatchexec"
  url "https:github.comwatchexecwatchexecarchiverefstagsv1.24.2.tar.gz"
  sha256 "d863b77332bd56cd37a45a99ae2be50a9aa332b66b523a4a76676bd778c017d4"
  license "Apache-2.0"
  head "https:github.comwatchexecwatchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:cli[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3562cca01fbb60ad0687c8e037ce07f20161d033110429e45a0c69fce761dbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13ee1b5f0bfeb0db99a4b9d08031f21e40696ebf442ba5f2797899cf345c0477"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3c66f4445ec2bb111abda50fe9f533b52a757573f267ce523e7a7a7f22ae664"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b6b2dd37a2d342ad7bca1cbe27344668c775c0b7d72e1c8fb6d4fb4f9b18a3d"
    sha256 cellar: :any_skip_relocation, ventura:        "7740cc45f1513ab7212bd710ca8d86cb3bce96ab1664b7e8084135fe7f5fd4a3"
    sha256 cellar: :any_skip_relocation, monterey:       "15fe92c3102ae65a7045818bb782dfa5bff2e3beef513970c7a19dd08dea8df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac223703a183ea75b536c2549f8c864545a68568c62215222caab7e7c371832"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    man1.install "docwatchexec.1"
  end

  test do
    o = IO.popen("#{bin}watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end