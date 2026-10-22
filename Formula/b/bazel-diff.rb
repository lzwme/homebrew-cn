class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v64.0.0.tar.gz"
  sha256 "38ab843b3c3fed0e6195b4ce947ae982b7b4f9a1565dafa3a77be10e6a5ae790"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "feae92a9dde3a176cde2480eece9529076fe1b4e6112aa60821a6ef0b3c4350e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aedad33ed1d948b2c579d9ce33c2fdda63bc647edb86800a10087e7f0896f1a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db109ffa2ae7b634629ca9580f412153396d1b5cbed71304b6009d2e2ca7bce8"
    sha256 cellar: :any,                 arm64_linux:       "784bc09b197067edb0203ba1c4a7d1f7a01b48e506fe8bdd88357ddc9e18e6ba"
    sha256 cellar: :any,                 x86_64_linux:      "08b9ce1cab2aa00f75674f05c244cc9562ea0c935bcc3886b94fb257631e2250"
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