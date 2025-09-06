class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.690.tar.gz"
  sha256 "4d9cde24c565361fdfcd8e200e0f466032b4b24968719608c035a4bacec814d8"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6765f1ca5c2b13154daa18000c6b1229d9ba232c76f67891ad7872c6a600e399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0089df1850902bef1ff963176071b528c2d34f6ed25d425675429c81d098094d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db85ca0b14654a3a04ffbdc1c4e319327a217b3fbb28fbbb524bd3eb17a253ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "260af78e8f5d95824de1ea2cfddb85dc9d64c9999301fabecf6cf70cecb9c9e0"
    sha256 cellar: :any_skip_relocation, ventura:       "2fbb70fb37c77f5afb883a97c2aeda91853956fa37b8df5da88d3951ba28396a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b161bccb466140161f118990adc101a58c2efa67aa9a9b2743a58eb8176f9f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdb8e1ce6fef6e4b96c6094ca334d780474c99debc28e5dc5965fb4e215943b2"
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