class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https:prql-lang.org"
  url "https:github.comPRQLprqlarchiverefstags0.11.2.tar.gz"
  sha256 "d4e59f72b32670908cba25041338023cf5de14507b76e141e2fddcf237eb6215"
  license "Apache-2.0"
  head "https:github.comprqlprql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80fcbc68a98d9187a809e94d08f8330e35f75ffc40a1112ac17876a83af5c682"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72a1287cb1d8762e52e098bb0044b6382694c8007e26af50ce0cb57301cd007b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a4adad8bfd336af0fad92e908e9337dae90f3bdd4bd860843c58278df50f77f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0c84353d4daeec91f57c213c8766cf5c60dc3b1d6eea00eee38caab482d54c5"
    sha256 cellar: :any_skip_relocation, ventura:        "c7842d46aab623797d00716be3c7e7669a98a78adcadc42c76c0e7d956d28ce4"
    sha256 cellar: :any_skip_relocation, monterey:       "ab830788a0a942b509940b7bf5eac67935a0f0d1cb1df527f012b7d73911d2ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e992dd5e5227d160ba5c923cc9c6fcf62e040a002fc32e4ebcab66a158649c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlcprqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end