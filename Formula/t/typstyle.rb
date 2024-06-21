class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.11.27.tar.gz"
  sha256 "4d452679b0ec7b82634394127bd7d95198d2ae24c31b524a81278b0d228c8c3a"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd9bf64d0dd6a6350667ad4d5680bbfd7e6ded2baad627c3b266f2d4ea5f1fb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca2fec2250204bd88d9ab55f81dd68b00e2b318fe562eac5ace9582f2e7b9577"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fcd06063cbdc11b5da7ebc73bb06e9948b267a83512a36edd28c9461aa0644a"
    sha256 cellar: :any_skip_relocation, sonoma:         "06ef17f7872f2d01e10d7a564341656ee61f854c76790125da1d4201b40c63cd"
    sha256 cellar: :any_skip_relocation, ventura:        "39a42cc6724c15c055185abdc9d9d88ca53b222f79f3ec6d1a5720916a115a3d"
    sha256 cellar: :any_skip_relocation, monterey:       "72ac8de9564fb680a5096cbfb60752d5cfc1a93790a5adc7db82dfda3e684da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b745723873e2af518180392444b3a9682c8843c586717e88c3e532bd2900d4c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end