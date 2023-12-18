class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https:github.comoctobuildoctobuild"
  url "https:github.comoctobuildoctobuildarchiverefstags0.9.0.tar.gz"
  sha256 "13240e1e75908de4d9f8d2066ec35305bed7b0e9d05ce44f98b4449de13451d7"
  license "MIT"
  head "https:github.comoctobuildoctobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bf84a536b72418d16b2572cf8755ab7f405549ac3001183dc7ec4d85f8f9984"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "722f6950ace4d3ac711e0610f1646d2041e5eefdb1a2a17b933065e916dbd8ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcbfd769abace0c6e504358df6703fc68ce2b0f3bc710e82f2cafd94b1ea5ed1"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4d7343dce010e9e2425fc244b20ec87722f1269800c233e134d1e69ead1c827"
    sha256 cellar: :any_skip_relocation, ventura:        "62ab7039287a5b351db22f9545741c79d2e533b3b2e49e09aa14b8052910c54f"
    sha256 cellar: :any_skip_relocation, monterey:       "3e6805ee12f5d3ef1b6a61efdfc5714dc9938b756fba4b03a2f978bcf1f85fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4662be8133c46fe615239b03b39a7655ba1fd6de717f17c85fabb0ed52707c23"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end