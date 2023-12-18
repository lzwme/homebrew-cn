class Svlint < Formula
  desc "SystemVerilog linter"
  homepage "https:github.comdalancesvlint"
  url "https:github.comdalancesvlintarchiverefstagsv0.9.1.tar.gz"
  sha256 "c3b14f248c7ecad5a565cb357f0e5f02cd0d2c8d551e0f7e3b39b624d47ee9c1"
  license "MIT"
  head "https:github.comdalancesvlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "180136e14366c7312fe90b8a75636b48b5064ca66ef30165c0855bdbb7ec5dcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87d6fd56b02f67508d6a9171548994ae11222cb39438b49b1a3368eb6b58ffdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c67f971a91e76a5fd273a453bebe3350e74fa7f06f44a27ec03df681bdecd106"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d9352041549c9a1c44517abcd80c131b8090174f59b80e17cdfecfaa68668c4"
    sha256 cellar: :any_skip_relocation, ventura:        "feffc8305f663365b0a07338655abc8160c743fd551a7cee7abbd7cb0d08f2a6"
    sha256 cellar: :any_skip_relocation, monterey:       "623f2ee3d2ef5d98c706bc660bae42ffdf092acd8dcc3f2a5a90e13051961c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dc787fe7b36d997b50b66716e6e384055abe51adcbd6c77c07037860c1bf4cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"test.sv").write <<~EOS
      module M;
      endmodule
    EOS

    assert_match(hint\s+:\s+Begin `module` name with lowerCamelCase., shell_output("#{bin}svlint test.sv", 1))
  end
end