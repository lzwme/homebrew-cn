class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.667.tar.gz"
  sha256 "a8ffc0c8505fb0546f9d0007f3a2c74b08e602f5a6b864381e3a24fd74e936bc"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc3f1c0b4edde6303220623f9b828bd02ed02196b7e586966ff0cafd8aebcd31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19107fc6296f4f2f73ec541b81163bc14c4c763d0346a059b7ce572c2d7251b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6db979fa6009527be740fd177548f9e8b7cdeec371e623acd46e9124ba3a714d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9817da127439d658240ba51f9b374c7fffff7375144a7f1502bdc8dcb17bc2be"
    sha256 cellar: :any_skip_relocation, ventura:       "e11231c9ff16ef3e7af62f14c1588d704df1ef1480e86cf760682070a9c29429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f374d3aa0f4c634f53c6c7943ea5a56f6e9279ca6120246ca755d30d4457cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19796982bb76c9ff6e159afb16aca9fbee44128c34517a92b9631c34b89e7496"
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