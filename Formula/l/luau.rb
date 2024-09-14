class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.643.tar.gz"
  sha256 "069702be7646917728ffcddcc72dae0c4191b95dfe455c8611cc5ad943878d3d"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4552d10fb5efb2b4849f4ce088f8cb0391687c1b26d84b2e444c19a8c71142a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9291a450c6754964f845e329bd9b7a16a8fad035fe3e34009b2dd187b68b9b7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4794fb73ec744035c1c87f9e2a8d71ca224cb9de024acea7043eb039226c918"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e538a986a0435b0e77157e41054035dd41ab51e1c2f19bc9ba73e84164ae2bb"
    sha256 cellar: :any_skip_relocation, ventura:       "ef5787222a9c63baa82352d4fffcd5a76273b16a0f3dc7ade0a8998522227e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7b7357cede45f8fb82c81d5476a20b3fc2e46db9fca33d8f043780147d774f6"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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