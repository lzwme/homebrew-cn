class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.683.tar.gz"
  sha256 "a2c7aaf906d625e43ca468792acf8e47a9cbd1d4352623b5e62d2a4011faa15c"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73695afbb5c64ededd22346827b1a7ee0b66bf904bc97b38b469cdc8805c5fb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f07a744e6e15bef699d501a1c932cf75474ed84f0212d4e76b87c8ee4e25e2d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddbff13090c1ceb39ffc0f26fba20e8307d65230a79726910d014ebc0477145c"
    sha256 cellar: :any_skip_relocation, sonoma:        "42e2bb43a840723b4fb9b6b5c71b929ce51c9254acbcf2fa1ce553f4d82bc38b"
    sha256 cellar: :any_skip_relocation, ventura:       "127249ddf6d8922280a0360ce922ce59f102ff2df507894c355ce9fc09ddbc6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0adbbb80854e87e28bf5cc8f1042bda1f6f83f3ea261cc77fd9459928472a990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e98d3b19b02376f5b891e493d2717ff4277ef335e7d10f135ffbac5beef43b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end