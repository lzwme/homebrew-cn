class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https:watchexec.github.io"
  url "https:github.comwatchexecwatchexecarchiverefstagsv2.1.0.tar.gz"
  sha256 "acac35485b57ebf494b1025550eb88dc534841e4081dbba47ecb0168e7f214ab"
  license "Apache-2.0"
  head "https:github.comwatchexecwatchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:cli[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0763226bda6843305e1a97da4a8a1ec965e406cbef9fc0281fa6b185720ad94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d381bec9c2e3a3cae02f34b6468dda00a94e2785ec33dd3fd2196792628c482c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bc606a3faa9df8b9a179e5b0c5ee8d45534761abfc960531951fe9c061b3fc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0df1375113418dbbd9c752daafb3c22ba71fdf2aacd2fea0526ff4f02276836"
    sha256 cellar: :any_skip_relocation, ventura:        "eb0f241cef937b89566984bfcbd8047d0989898dd7d1b814909e56eb7ea12985"
    sha256 cellar: :any_skip_relocation, monterey:       "fa9a922b958809080ebac41152ac751d08211f7e8c0f87a0411cf3821773f717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ba4821d36f0114b37e8e457e9e63a74b1ab3b14f2fdb5826aa162ea5356e7cb"
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