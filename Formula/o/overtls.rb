class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.32.tar.gz"
  sha256 "1b52591611cc2557d245656aadab72a1c6a9d16205bca3f3d26dd93c2d8eff90"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f43bf83e5853f0b7d8230cc8acf1b2c53bf3c4f6b69b26f9150fa00562ec4ed4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a128b828738729545421ab315f38554e7ae54053c484b5e11b173746a2616a07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5693d4d4343e86e7c619ab7042ab2157f8498976510f71055e254765f4d128c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "09d29c8ba6a7a2779294f194a87a2f39a55c2c68e650e222cac035fdcb5414e4"
    sha256 cellar: :any_skip_relocation, ventura:        "7c279ed840cae0985dd510f01c070efe8288ac8a96582cc077f5f59f4d5f9b6e"
    sha256 cellar: :any_skip_relocation, monterey:       "b52f2d8b14513bc159a5332b1b65c499ba70bf36c18e3a0e008e1f1398325191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b8c80a7624cc2220c95d1cb93190dda829742598f0e92acea369fa42ee776be"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls -V")

    output = shell_output(bin"overtls -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end