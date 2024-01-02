class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https:watchexec.github.io"
  url "https:github.comwatchexecwatchexecarchiverefstagsv1.25.0.tar.gz"
  sha256 "a440554e6a73127c87c39d39c32ac1adbb58c0007765e521f11260cc123790bd"
  license "Apache-2.0"
  head "https:github.comwatchexecwatchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:cli[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c400911f65f854198def1b03a4cb87d525072532ef3856f3f8835d4a022c3d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "286b5d3ef0dd82c91c37a88c852860e2ad1415ffed6d925501e1038caaf7c536"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0255f2181e1487bcfdc000a24fed2c57674e9084deeca66b1d61df1ed2b2ff7"
    sha256 cellar: :any_skip_relocation, sonoma:         "257613336a739ffb09dcee21bba8324f645e465f91c81a789dd6225f4443758d"
    sha256 cellar: :any_skip_relocation, ventura:        "7a80a7c5be0a2fa322c8fae3fcb1fdde2bbe93dfb8d7a1db7d4fed871013eaf5"
    sha256 cellar: :any_skip_relocation, monterey:       "9d634ed4f8d56fb123eab4525d6bed1eb0833b304f44517c75ddfc6d4311fed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a5e60620c712c644e2a80fe503c07ebaf69b666ff17053236a99193ae8d513"
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