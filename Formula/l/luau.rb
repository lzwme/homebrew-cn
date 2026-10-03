class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.741.tar.gz"
  sha256 "deee653d0f5971b809ef67f50dbe8109ad369d7575e344cfe2013774fed2f4c6"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9d15090b2166c2bfa16c8ce1ffedfeea2fdc12b6d43668ef2827d05431ea6ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c134a2cf2e20a094ffee5f71ac239da6670489ac84a73d04eb4d2c48fdc48b2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0add7b875e575ae122d6712cb3a12060a8afff9cd5b2324a36b7a7e5805f97fd"
    sha256 cellar: :any,                 arm64_linux:       "51781383c21303ce8ce1f3cad2daa98e53ed14ef07bb3cf5d2877a021c7da31c"
    sha256 cellar: :any,                 x86_64_linux:      "d9a2057f09bf2dc57c04965822421db53a95ef6544d1f273204c1638fa0cf453"
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