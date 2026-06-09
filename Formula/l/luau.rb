class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.724.tar.gz"
  sha256 "4631f584b409a985b7daf52697dfdf26b2688bd7395afb09ef0f3937e7fb876d"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "475faa1d3325d9899952768bd434aa9d10bfc98487be5228de53bc68e6dcda13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2cad43101a5a1450496dea66f0c9c4205dc157144a7cb617f80758bc3df33cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8303bb9bc4877009f00e081b6860c0aecb54f1e817c2318a187476983440b908"
    sha256 cellar: :any_skip_relocation, sonoma:        "85f9b2af44a453b94fedde2a8597de3ba52f8d0fb914321c44d293ff33f6694e"
    sha256 cellar: :any,                 arm64_linux:   "0578b8ec38b7c77f1d41825ac458211a4096ea355c665a0eecdf5eb4278c165f"
    sha256 cellar: :any,                 x86_64_linux:  "db88cbadf3884cb4d93fd3a45de034a0cf0fa292235046fa477b6106b42624b7"
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