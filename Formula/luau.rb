class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.581.tar.gz"
  sha256 "d9f8aa595d026c9f07b8eb559c27708ab48632299f08ec5afc8b044f3a30d35d"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6269aecc42b41bcbe66ceec853d91e301501c07a2084f93556a5c7d6a310c66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3753a50ce47c3368c19d50e389bab59d666b4150c00844c91d17704df20a7db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30542cfcdb5f9ff8f53100b5c24341e1d428306d7111cb5f8fc8cf4acb3890fb"
    sha256 cellar: :any_skip_relocation, ventura:        "52f33171f1f4ac8c5430ff76bb665a5220e8a229786ec6836fd6361ca24a907d"
    sha256 cellar: :any_skip_relocation, monterey:       "505fc480881c2ef30f7b443a65b8628575a259b3eb51015146cbe9df2d1f5137"
    sha256 cellar: :any_skip_relocation, big_sur:        "47d1fcdeb6b17bea5936d4272a680ffdb0037bf64ec3dceb0d0299d6479c6444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b39317f9d60577a1a75f9dac97ad2ab9d4e7d7055bd7cfe5847dec36cb4b442"
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