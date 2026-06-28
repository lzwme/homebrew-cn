class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://ghfast.top/https://github.com/lance0/ttl/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "ab6c684f4c5804427fc4a540c554cdcc693b039c76dc2ada24b24fa4fdde00d7"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6adba43ae0471bc7ef4370926f035ededf9a3dbac53b47720ed59ab6c6769e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25308d8517b8e5173b4e879379a5b2fbecfca6ae5a7a03ce6c96e436aa5f1b07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e8c546d5771b3238ba4df23b6402e32d573d6641e3e39eaa0f58b5f3287242c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac0b4d6d661cf7febec6c16e1981a64cb46c0600cb4c52d9f14054df8ed7f881"
    sha256 cellar: :any,                 arm64_linux:   "815607579ccea7cb4ee5ccb86b614575fdeb36c4068543a2bc17501e445eafe7"
    sha256 cellar: :any,                 x86_64_linux:  "185e986e8efed5a3fe7840691aa2858802e5859bba20c1d4a8a0e73e94dcf91f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
    assert_match "Insufficient permissions", shell_output("#{bin}/ttl 127.0.0.1 2>&1", 1)
  end
end