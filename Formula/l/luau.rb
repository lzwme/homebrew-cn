class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.642.tar.gz"
  sha256 "cc7954979d2b1f6a138a9b0cb0f2d27e3c11d109594379551bc290c0461965ba"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "31d32c14dac829ec421d224b3a0676fb258beee9293e8de8cba3e602d31936bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cdc703190df61105a7ba9f2266bf8c62b03376ece42af49a19759675f6996cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2981c6bb606bb83a177cb0db8830dba0b7b68e7c5f4c7442aa554ab1bfaef87d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77a1cfcd7faf586a3ed23f44b371420a7f745d40aea3614eecff78cf892777ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3a1b754f45cc6590f7eefff68aeff37537f4097750cec1a65eb9eaad17eb866"
    sha256 cellar: :any_skip_relocation, ventura:        "72e67586be8fa2be29df2420618f11201bb0d3a5f36432aabecf4cb0c3109ae4"
    sha256 cellar: :any_skip_relocation, monterey:       "f1abfbf98bd70d1e615d5a85ce30d6e426fcdf42dcd1b6ec6a74902f07c9d287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1181e4b8b317c456863c1aa9e0def0a437057a559605c105d42d6e21b74ad42f"
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