class Headson < Formula
  desc "Head/tail for structured data"
  homepage "https://docs.rs/headson/latest/headson/"
  url "https://ghfast.top/https://github.com/kantord/headson/archive/refs/tags/headson-v0.13.1.tar.gz"
  sha256 "b6d5bc2f00e29b8f3badeb33c7756a3ee0b6c06b557e7510b62484256ce39783"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a183204447f3e0d36c01490d49154107df470f6dcfcf1564e2a22c308e56be85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9b5c6c6c5819d2bd2a5602eaf50727542b6965757af3b22929d254561e2cac0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c7e153ada9bbb2cff6571539e52656c08432bc975cdc5c5e5e61a3f3d2f606"
    sha256 cellar: :any_skip_relocation, sonoma:        "e18389f40ba23ef4574acc0ad6604dca5a32fe235b92bd6c5851335474e5a786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91ff96c16d0788629f9bdde9b1b4c7e0c75332f3ec01c6d87774dfb0471f12e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2046616b0f7090457f75bb39e61d7f1b6fe81b6db53d17054b8f2b021d75a9"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hson", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hson --version")

    (testpath/"test.json").write '{"a":1,"b":[2,3]}'
    assert_match '"a":1', shell_output("#{bin}/hson --compact #{testpath}/test.json")
  end
end