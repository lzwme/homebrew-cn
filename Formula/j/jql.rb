class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://ghproxy.com/https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.0.7.tar.gz"
  sha256 "b7f89239ac566ee6ea23216a3896d3ff5ce85b12d7dc57a44a088396813c142c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0434ef10f06e4f578216477c9be429c18983eb7abbc0e5b72dd8463010aa96e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87d72d897ae92c3cff9c4084246cec4cfa7c645a8d1ce27e9403140883f75c64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a321a1dc4f4ba2682d7a7a75dae54d9c2dec5944ff40ab92f7b3bacfdbcd9f91"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dfb3ab4accd48af85caf69b717feb40b3274747ede5949fa3c8677f4072c21b"
    sha256 cellar: :any_skip_relocation, ventura:        "3fc25ef8b6ae1a5a4f174f7177b1f54f21647d88df8ee4e82c103aff340b7a3c"
    sha256 cellar: :any_skip_relocation, monterey:       "faad65e11acc16d7e36ad68909a3d05623229ae92193ec5c980a9f0f32dbf85c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "242c274a1d502f7bb693aabbc42ac136271d0ee1d1d3114de42784400ff1a818"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end