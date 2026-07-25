class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.731.tar.gz"
  sha256 "c5cd8883a49b99170d66c6e791aacb8d15e1d96c3690b0eb5dde2b0037ac0733"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c24c94107aab3e712c33fbffd91b82f7e5cd6d9351a1788127f4ac431fcee28c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96c17e8ac6b2ff1c03a00d1a75220d77cf63a52d829ff89215b5136834810d30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa8569a0dcbaa0dab1e766ea80243e973cd34505415300a5cab9715ec5e3903d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6912770f8e7e5a606882e5b319fdfcb5a69b68914e1672ed316effb5c74f88b"
    sha256 cellar: :any,                 arm64_linux:   "9bd8686d738c294a93f56c78414ca3887ba6b7f3ad5495aa1dd6b37dc36b4ff9"
    sha256 cellar: :any,                 x86_64_linux:  "60977c98e7175926ddd4b476aaca3e869f681977e7a97d8073f50100e5939bf8"
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