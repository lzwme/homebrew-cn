class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://ghfast.top/https://github.com/doy/rbw/archive/refs/tags/1.14.0.tar.gz"
  sha256 "e754da1cca32593e8af6b5d24d7a1eb82bf00e9811a8e42fd7293a6e36724f1d"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "771d388b6d3980a74668957f512ca60771ad5dc29a9dc497b238b52e6c23b330"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05dc3bed3f817d0468ed56f0a3517af452658e7067a1009d16f9110ec66de880"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "233ad3a9f2fc4644ac307daf4c9483ed330c50f61bc941f5ef7632e373767d95"
    sha256 cellar: :any_skip_relocation, sonoma:        "38c19f5ebef4ab0e778d558e3c6e89c1ebc4f5ae00a764343802797ee9c205ee"
    sha256 cellar: :any_skip_relocation, ventura:       "02926b436afeb63fa56b0eaf886152f1fd6a50ee75c729671bf7f38e0b1a461f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "836ce02ed905d8626c421bd4d423e444d3d0189c8df14bc59ea294cc33dca80c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eec34ffa444825ad12980a226d6c6f9ecba4e5eecf87845066319346941529fa"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end