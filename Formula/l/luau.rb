class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.658.tar.gz"
  sha256 "359300c8915697ac63abf3644472545bd263726222b30a4034683e888ec07108"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c354d7cfd0b1674dbf8a6de59c88fc70f9c8e913a9ccbe6a7a40eef23e2e4278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e44a9517e2f805a0a2aa7d960649db2df3f33a2f70c18cd176ae293c4d02f0b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78f2600fe89f142288f9523ecf3f9ad964a6e4cd716b08a9c340c0e03495e81a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1e1df610bdf832d8d58426b945ceca23e0478f24cfc63d09bbece646dee2d1e"
    sha256 cellar: :any_skip_relocation, ventura:       "082b96eb9c69ea10a37c58db2be501cd758c2ce2844e278f445b3ba987495bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93ed2f2681debfcd4b2c75356aab99c3bc2e91dfb58033ecbee7763ed1b2d42"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      buildluau
      buildluau-analyze
      buildluau-ast
      buildluau-compile
      buildluau-reduce
    ]
  end

  test do
    (testpath"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}luau test.lua")
  end
end