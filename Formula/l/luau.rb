class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.692.tar.gz"
  sha256 "37405d66cf909bd2956ccec95c2239ff2d26ee57c13e7360d74cfd1954eb6981"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8031c2da4f69435a34031d257909791ff7ab3c6a937031132a4a59713f01427f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcca60aad85ffddbfa71bd2218a82b00084146e1f66eccb6f332ef5249ab7c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "084c9ea5505f84c825b5b5659f2fa0cb28800185e33bad09771fd2863b665470"
    sha256 cellar: :any_skip_relocation, sonoma:        "31c82676fcb22bd864cc8960bd1acb9ed8ad3457f537c8b556739ebf75397143"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a329bbbee3ab8f65502f74fcfee5489d2a02c45dedf4dad994e637e2244774a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc23ca220599a3d47b76e4cdb887936525065fd1e416cb115c7098270269be6"
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