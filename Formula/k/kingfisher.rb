class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "6c88c29a0e4e888538e027b63f3b88735919adf4f5aa334114ed6e09a7d2ed7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15aaf5f988ea3c24109124d194d6ae13a6a282e7a5af4f2ff31d0eab360caf36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "537728904beef8602c796bd143adc74292c9b4bc10f7070ff6138e318a59ecd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1a483e3941ad969580b5df6eaf776e36111db8ff91c8e1b5ea3f9e499bb5532"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fd6faa04133efc8cae4b8315d88f4bd2e88e5a17d2ebd8622ad5dfeeafa60f5"
    sha256 cellar: :any_skip_relocation, ventura:       "796933bbd17af4cedb948685ecf0d9e34229a7052e1197524531affb898ead4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e11eaaae6da854f41e8bf61d0464160461ce7f64bacafcad254013b408c1b138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c3af2fb6a42179d692005d3659f365f834e77dc99bc8674a7704a3e77c66763"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end