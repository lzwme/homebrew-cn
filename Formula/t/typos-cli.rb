class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.24.4.tar.gz"
  sha256 "2667fce50bbdafd0707ca89c83b39d9331990cf57ef107095d151e4d33eadc9c"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9036fa8014b2324824e658ba1dcaac87c82b5c57438564df2793ac26909e5b5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "731255b4907b3eafd2f410e0984ca92510fb232ddd8a69172cb497d9e06c68e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "661771d3b254c52354366642e96bbbbfa4ae19e159e1987b0103e22d61b5bcd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "06c531e0f912b470ad0befe43415894bb8a502e308b1d23ae56ae41ec8f0899e"
    sha256 cellar: :any_skip_relocation, ventura:        "806bf620090604d6969c5f7b40fc985a60f6fc413c47a9abf2c2f088aa51a23e"
    sha256 cellar: :any_skip_relocation, monterey:       "8947050a45ccc8ac94c066c386bdf63314bc5f216ce27dffa04e2596a0a65987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f34521721ccd63e27842e536d3b1b304bf923e3fd0727a7d1734c7c932a6c887"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end