class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "5c6b9085d50c48e619c82708fa93c0256f0a5589f597c3458279cabbfd21fee7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c6cdefc154fd543f80d35da0ac06c6a84245368edcbc4cf6a0bc5de8d650498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54d917c821247441f38d6235e833cee0daf416ef18a3367c979be866ea9cc199"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e86009aa74edf0148c8794041ad01426f65ce40a3fff0ebccc4ff0179040c228"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4feda79876d04011c3360cd12538ea638e442b5c7efd3049fa0d26ab709009f"
    sha256 cellar: :any_skip_relocation, ventura:       "209d50ae8feac7b71c819fc8cc50bc2315f679acd0904072766a1cf4c05b9dc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e528e6717ed8997576860f97656f50375b7bd7a728647b1f8a6656f03087d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b9e19d247604c15a546a6d7b381ea47b5c33e77f2f37ee8f7aeefed11615bbe"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end