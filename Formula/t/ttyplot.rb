class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https://github.com/tenox7/ttyplot"
  url "https://ghproxy.com/https://github.com/tenox7/ttyplot/archive/refs/tags/1.5.1.tar.gz"
  sha256 "5c170be08df3a7dad983994ed36d99c257f5a36c4dfa7ee7099393895ce82095"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbfefcffe08bc4996aed76350eb01a4eb06d628b751b3c24ef43da3ee9cbd172"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9881ee688e9ce54c7af9f29c9450980b2655903edd95499acd10f1511edd48b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22aec3b740a3021769ff7856d3551b78eb123aaf576c90cc1c34ec752adcfdbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "62adcf8960be6f740ef587e1449825f2e7a1e84709e396a19b04fc5d6c84c5cb"
    sha256 cellar: :any_skip_relocation, ventura:        "e4a058d713918e42d6167872bf5d2a9402b627dfcb7986c4f87ab4973b291ca4"
    sha256 cellar: :any_skip_relocation, monterey:       "3cab19df5f1ecf3d6230da30b53a997776a7703459b72c92714007c211ea0078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c63dfcbac92d4bed8702e494a7eb28850fa708f209b6cd2ea952394192a83e5"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    # `ttyplot` writes directly to the TTY, and doesn't stop even when stdin is closed.
    assert_match "unit displayed beside vertical bar", shell_output("#{bin}/ttyplot -h")
  end
end