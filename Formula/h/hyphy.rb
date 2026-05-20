class Hyphy < Formula
  desc "Hypothesis testing using Phylogenies"
  homepage "https://www.hyphy.org"
  url "https://ghfast.top/https://github.com/veg/hyphy/archive/refs/tags/2.5.99.tar.gz"
  sha256 "b73c884216ef55b2ad4a9d77c4589d503b0ffeddb64b62fa9658e948bad241b6"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "0480af62df4fd3cdf4d33f7229488e2c5d4071ad939f9c4cea0a7a373a68c3c8"
    sha256 arm64_sequoia: "57d30e70e9282358cdb75eb5a1ff32fbb71285f4bc9edf7146cfb6034eae3e23"
    sha256 arm64_sonoma:  "1760038bb3da92eac500a95b564af219048be23d891b9792ce76290c98f69b05"
    sha256 sonoma:        "4ac51d59fc2681e4393a7f477ec72f7f4c49cec7fb86c64d7e3e9424e0ed3202"
    sha256 arm64_linux:   "2434ed6d1d9635948549f616bbea9ed3682fb48ee75dc15266ca3fc9ea4ff6b5"
    sha256 x86_64_linux:  "7b0b102951f6b55a1a16bd9dde96123b598fab1bb977c9bc76ab81b1346fbb18"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyphy --version")

    cp pkgshare/"data/p51.nex", testpath
    system bin/"hyphy", "slac", "--alignment", "p51.nex"
    assert_path_exists "p51.nex.SLAC.json"
  end
end