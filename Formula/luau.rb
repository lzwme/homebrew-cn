class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.588.tar.gz"
  sha256 "a65e2792e3cbc285ba85155167f63d7862fe7c3667fd75493c9ff25284d2d9e0"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b82d0fe5774568b9b11b7d1622281efc9e19b4abfe48ca80b5b4593f81d75a18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "344224c2c007bd0cc87c90af2ca3043c1c294c7e509565597f840f931dc70c77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2437aaba22aacbc4dd07954449079b2a429a9e96053bd377397f3ac8a143e8d0"
    sha256 cellar: :any_skip_relocation, ventura:        "0d7d12c4c6266e85f217645113b06582b774b934e976af591355212584079079"
    sha256 cellar: :any_skip_relocation, monterey:       "efd77503e2612e2df5a770a799a0496e2654dd6d2b34a7b023f7d7116c44d3d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4fb8f2c13d9241a30536f0fa3abf018875e83ceb41e71bd1823996aa431a2fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3d84ebad2cdd0becff3baa7bf39a34ffda56f0d78ff69c327036b4f32f8466e"
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