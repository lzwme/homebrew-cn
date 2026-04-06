class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.97.0.crate"
  sha256 "dd975082a04f68337096b4df35ccc28874cdc670c27319715cd2f4afd3ccfbde"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5b6fb88074b315a88bbe14aa3882424bd75c8018cbbcb52c24e4b8a46277bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406404207b15e98c39bbee23bf4db350a254b451de4bc26d9dcec6930a5b3bcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2c7c2f12e7f7a7fca8d6380f7b58556ba17f94a52bc681c3ccbb3d7f73c8b41"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e50d9ce88a83bf3fc58472881c8d11603eea6942ec0411b8735318e428a8043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc2787b655b3e9094ca5b95b3e3a9741fbca2a91e6281eec782d3f5b968201d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8cbba497c42af26cb38374004180b956d4f4e180e91f6810357000d92933bb5"
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