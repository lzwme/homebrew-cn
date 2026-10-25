class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.744.tar.gz"
  sha256 "08b960d377e1c3d6727c15a5ae9d415f9236efcda3aad05bfd82498ab9c20f6d"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "844db74597e3f6ed5dc99a84ab5f1e24ba50c75289683d3bf06e071f7841ad75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f9c78c3d4156fa4be801ec6a12e0c7886af86aff6a5d2ca9129f7182bd304c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35d865b5f24e2ffa6898d955e27b1b9a31b3cdd8b1538ad69bacac3c9ee6c426"
    sha256 cellar: :any,                 arm64_linux:       "3140f200fd40ee01ef37eceb01fff79a195abed6cfa71c20414800b88798c753"
    sha256 cellar: :any,                 x86_64_linux:      "43ed4fb9dd240c465bb26af8f82cd09c1105e6b5bb8672869fb8cd79a8c73e33"
  end

  depends_on "cmake" => :build

  deny_network_access!

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