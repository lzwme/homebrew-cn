class Iqtree3 < Formula
  desc "Phylogenetics by maximum likelihood"
  homepage "http://www.iqtree.org"
  url "https://ghfast.top/https://github.com/iqtree/iqtree3/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "f748572d205609040a790df44c7bfa49d8b01ae174e123e927911696befd78c5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cab3a1cd24949b34b5a3b24d0938cb99ce5db4ce429efa3fcb15363742bfd32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf0c9bf82614a4305244242a684d0af7df08f10aeb4d1fe091d34928e1e6f726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9820899616131e280b8d2056e5189fdaf05f8fc60f711e423310057ee5407e0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ea8a96d0307fda78963450e916a8d1165b1dd788aa62d7b56e7202a94d7f003"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b16bc6c675401241e5b5997e6e2dc5308af39e2fe9fa4725de34dbb2f5d0b2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a0478f930fdcff812b88b07addaf69b52ec28bf893bb143b4451614e913a78d"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build

  uses_from_macos "zlib"

  resource "lsd2" do
    url "https://github.com/tothuhien/lsd2.git",
        revision: "c61110f3a4fa05325b45c97b2134792ff9d55d4c"
  end

  def install
    resource("lsd2").stage buildpath/"lsd2"

    args = %W[
      -DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3
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