class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v49.3.0.tar.gz"
  sha256 "4eaf85b3f3fdb4da0ad333affe9dbc578e959c1c8d51bdd225ac58447e0cde12"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ba162ba6bb22c933c8bab4bcc0b1d2d0b70d2fcadec34f3045f3145283b7937"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb8479613a2f730614a8c988fa0630adba8fd0c55d7c6dc32601b545d13ecc1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d28dfe04f101410becdc70d898dd8ccf315fed655c9c9271afc11c967e435b89"
    sha256 cellar: :any,                 arm64_linux:       "06547114e0f5f1c0ef58defefb16947c859d752c96d5e3b5665f6a34a048c351"
    sha256 cellar: :any,                 x86_64_linux:      "c345318bc85eb882a507e3a816a33af9cdbd1a820ddc7feb49654f15f532750d"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Use our protoc rather than the prebuilt one from `protoc-bin-vendored`
    ENV["PROTOC"] = formula_opt_bin("protobuf")/"protoc"
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"from.json").write <<~JSON
      {"//app:leaf": "Rule#old~old", "//app:top": "Rule#top~same"}
    JSON
    (testpath/"to.json").write <<~JSON
      {"//app:leaf": "Rule#new~new", "//app:top": "Rule#top~same"}
    JSON

    output = shell_output("#{bin}/bazel-diff get-impacted-targets --startingHashes from.json " \
                          "--finalHashes to.json --workspacePath #{testpath}")
    assert_equal "//app:leaf\n", output
  end
end