class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/refs/tags/0.601.tar.gz"
  sha256 "b298187c5b95ff0121bf8cd44c3743be4100bf2f566bc5756503023350dac712"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4a1fd2f6662eafd390562045dad197c92d9a05fc1172ca7e1928c0559000dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6417726cd44c643bdd54890408a2e0bed134e33b87d8a1795ee4b81dcaec1e60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b2e1fa642b7094b82e4723ee843ff96288050d40d9977481ebdf5226c16a5b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b526346c664409024e2743f6cb883c5db00f8790a92556673b207f39dac25047"
    sha256 cellar: :any_skip_relocation, ventura:        "bdc9cbd8900b278e504c24bdba4f30046d71fd9cd5abd60a79b99bc385973e07"
    sha256 cellar: :any_skip_relocation, monterey:       "0b4a17226ff5b7b4ab94ef155321e217264bb65bbbe330477dcdbc27e38e82d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff4d02861983d9db3e78ac2f3aa77f62b40fac879c2bcf3f0f0a5a1af630b2fa"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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