class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.589.tar.gz"
  sha256 "dc4489de52dbf29cd3d04d78c1112f812e04a03b68d57585749260ba791e65ed"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65d5cd8a48952dce6173e68d75549a06c86410101d07bf7cc0e754472cbeaa44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54b856d3229a4f64a767fccd9413f8ee91e15654bcc41c4fcb3c7b33dc293bd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f0020478aa2fe6e950b3c9d0e0cc9ede186d6ece47d7952036f2af15147bfa1"
    sha256 cellar: :any_skip_relocation, ventura:        "3ce5b28aea96e76eff60795c3579b19aa3d604b50b96050ff0c3285441680c27"
    sha256 cellar: :any_skip_relocation, monterey:       "79222900654e2ecf7d99ac71a1a4d1fbc8449f3c186cf9c74848fb654ec21452"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e2fd0f4e5a68cc45169f82b354de532836fbdcd4341ce1f755169b0e3e953f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cd1e3971157fef89ba124fe4f5128ba414747050d1785e182b19518ba7ebb5b"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end