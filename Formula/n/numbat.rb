class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://numbat.dev/"
  url "https://ghfast.top/https://github.com/sharkdp/numbat/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "db5d9c2c0ec113f6773c22e7c09c51c08a62a196ca28a2008ff11546c77297bb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36a46f78882d51a4e80b85dcfcbc51b291e2be5ac56e2affe9e14eb889262243"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a04f4871ef1b5d49dec71a879c30235996175120f613c117247fa77ff38dbc1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf0d3f92ce3c472a6ef6e911f894dd3d56415e7ba0a9cc063b01e04425ed6801"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e0286914569ad1af581e121b290384b12af2235d6ca829e3000448a978936cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad8e3ff1ed58c498745b9fbf9d1d1b94f953d016d5072f567cb9be50b9f2f59f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b078ee0bd2f73b6d356ee395d787f03094c565bc77638ca34da807eeb0316205"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end