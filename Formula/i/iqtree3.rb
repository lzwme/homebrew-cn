class Iqtree3 < Formula
  desc "Phylogenetics by maximum likelihood"
  homepage "http://www.iqtree.org"
  url "https://ghfast.top/https://github.com/iqtree/iqtree3/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "b992e4c4a5429ebebf5b37ae7134dc3d6e3ea616f04cbb021947dfb7d034fbd9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41765e8f449e20786670b9e93f5dfacb162b5086fbb208a00652f9e753a3165f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abba490ece6c76de88eb72d1ac933baaf87ac25c88ee63a03c55465e2af3a2be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9fd8c20f841891b96074a223aa156974837629d621d5141a4f34b05693ec085"
    sha256 cellar: :any,                 arm64_linux:   "91d0dd57871331f145a0b6241871a5dff4c087b9fbde9629ccd363cb0d776505"
    sha256 cellar: :any,                 x86_64_linux:  "0720ae356d1a6b97c8eaa708578c9d4a6d789ddef60fffe61b1163f9dd4427ba"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "lsd2" do
    url "https://ghfast.top/https://github.com/tothuhien/lsd2/archive/c61110f3a4fa05325b45c97b2134792ff9d55d4c.tar.gz"
    version "c61110f3a4fa05325b45c97b2134792ff9d55d4c"
    sha256 "9bbeaa0f8f35783c1d8dec74df6c93a804dbca808fa04484f9123de4e7258b53"

    livecheck do
      url "https://api.github.com/repos/iqtree/iqtree3/contents/lsd2?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    resource("lsd2").stage buildpath/"lsd2"

    args = %W[
      -DEIGEN3_INCLUDE_DIR=#{formula_opt_include("eigen")}/eigen3
      -DIQTREE_FLAGS=single
      -DUSE_CMAPLE=OFF
      -DUSE_TERRAPHAST=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iqtree3 --version")

    cp_r pkgshare/"example/example.phy", testpath
    system bin/"iqtree3", "-s", "example.phy"
    assert_path_exists "example.phy.iqtree"
  end
end