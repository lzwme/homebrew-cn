class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.679.tar.gz"
  sha256 "df2046d8f109ef31230864e81737dc137d25a5d316421426d5a68a8d1718605b"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f40c9363c94c88dc96334db2f88240358aae1f4c03cbd74fb8b7483b2758b26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44596aea00cdf1fcfb9f021f377672d903327227a8d2137ce95e331d6c7a776c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf16523836a27ab65d1fcc771362de2e6edff2f08531cf858ba51438bc813e08"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ff62cc94330059616bec07b7419ecaa5cd6e51d6289032c70ffa9277b1f7972"
    sha256 cellar: :any_skip_relocation, ventura:       "abf38c8e4a20df8425751e3167ccb8f398fe67f9211bf225fa423ee17e9b69dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59b96cf108e83473a0501f171307258b391fce8129b2816342a2aff2bac2b2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5de8b6eb2f787e1be3c2cffe60f823f21c024111163d787cd0559715cfdd635f"
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