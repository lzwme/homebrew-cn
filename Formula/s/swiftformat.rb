class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.52.11.tar.gz"
  sha256 "7c27ffb780f449dc16f7d29d620cc08cd47d2dc117cc84d19ddad2a7e8d05972"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1dabab20931536f6cb157767e6e732ecbabb093ffaaae7325f9971f3c6b6db5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2674f87602a4a6d6af2f6ee822f7e36eb09c65e4bc31448d79d8955981645b1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1581f87673144bd34caa286b236e0c9d9cae42c20f5ff353ec7d139d03b63fd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d10f7a49255b390e1f8f174947427ae12b3d60477071b6922f0ae59579bebf16"
    sha256 cellar: :any_skip_relocation, ventura:        "8505abd9424d6bc0b992302fcb319aea05119eb2397ccc6777c09e6932364c74"
    sha256 cellar: :any_skip_relocation, monterey:       "c13826f376fd6dbf5afb4d9a435f39abb10b795473c8f25b9db986c731d627ee"
    sha256                               x86_64_linux:   "c9400f4f4641d817facf5621eed3d2fe078361c83c80d34b91763185068ea740"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleaseswiftformat"
  end

  test do
    (testpath"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}swiftformat", "#{testpath}potato.swift"
  end
end