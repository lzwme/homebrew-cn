class Rp < Formula
  desc "Tool to find ROP sequences in PEElfMach-O x86x64 binaries"
  homepage "https:github.com0vercl0krp"
  url "https:github.com0vercl0krparchiverefstagsv2.1.3.tar.gz"
  sha256 "38a6ac4d1b97468c81b4da93d62b46d4486817b02bdb53de7f1196b4938ed2bc"
  license "MIT"
  head "https:github.com0vercl0krp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f0159a4d76a32e6126b3ac1375eedebe325a25c182184945a9b57674b0daa0d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "437df8822a4b9866faf2043ec857a9b343b67e025fd5bc7b2a3aaf5740fc252e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35426462210f4dd5eaaceb8df295011bb12aa5b72a46e5cb5e44605d6dd946fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "281f5d8df4c7f005d0ddf5dffca73238d3e9bc0a81e73ce2cdf2808f31d9f286"
    sha256 cellar: :any_skip_relocation, sonoma:         "8713a1a59853c967bb9c092143f09747bfeb260a328aa77fa3307040f5270da4"
    sha256 cellar: :any_skip_relocation, ventura:        "da1a88f4112dc24aa95895004ad5d33609a1d7f1f4ce8824f84cf0f43fc0f384"
    sha256 cellar: :any_skip_relocation, monterey:       "5513b0659df6a25cf2b244fd5758f9384e1cc7e9157efb7b0bccc281a9e00252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc83b397da9d66104d009b5a91a6b37a56b2b792fa5db52347b29027a66efa34"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    os = OS.mac? ? "osx" : "lin"
    bin.install "buildrp-#{os}"
  end

  test do
    os = OS.mac? ? "osx" : "lin"
    rp = bin"rp-#{os}"
    output = shell_output("#{rp} --file #{rp} --rop=1 --unique")
    assert_match "FileFormat: #{OS.mac? ? "Mach-o" : "Elf"}", output
    assert_match(\d+ unique gadgets found, output)
  end
end