class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/refs/tags/0.597.tar.gz"
  sha256 "7b3109397d3e7949848de414ddf721f3bcb5ddbc41aed07269f62e087c925e18"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0367c4f34b34f52a0c3b03164aa10ef1fe2d8a30e9861927445bb8c6f5490b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b96bb5c8cfd069fe6bbe1fc2f9bc119555b61e517444a935a0dc9e544a08927d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2875f1a4ccde88691911f428b1a3ecaac9f95a81bb1075a69be443b37a72032e"
    sha256 cellar: :any_skip_relocation, sonoma:         "37320883d51e66d64f3e54dedc79b88f21b6a304243a0ba585ea0dfe49d4fcaf"
    sha256 cellar: :any_skip_relocation, ventura:        "c1ebe0bfc0a9b616dd95112aee97ef17824678c41bb456cabcdc3d54c5577a6d"
    sha256 cellar: :any_skip_relocation, monterey:       "f8ea17e803df2fe31744d2864f33f520388ef9144180156e9c81cf7c977e14a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b74bbef4be56bfb34008bdb311301d6ac0b3e6e6644c694246afa17183d7a9"
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