class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.105.0.crate"
  sha256 "423b5452ecd80796e60fbebdd727ae4a645e811bdad849d57b27e8f8b7b80161"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b2df6375100177650a68fc9cd72f17d571c85f073fe66672676cbb328cb07da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d1dfca35891cfa8d4e7eb305e0374756b3c160711f68eaaef8c318920d8e9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a728215bfaef12096702254c436caa3107f564692465f0c5e98bd6564248552"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5c398fef67bda61621eff032895b0f0f964ce221d14843dbecd9cbbff30f993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "439577b06307324db036daa379f6c457d9dbd6a8364b0f92b58bfbb09b997f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bcffc51b4b2fc09f0aa49a8fc976f3769dd5de0c90e03b5a6ad47d7657d2c62"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end