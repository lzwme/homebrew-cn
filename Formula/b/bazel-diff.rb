class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v66.0.0.tar.gz"
  sha256 "e3af26dc35596b05b17e5646b1c559519a798e09b2f7006978360910d9bfe5c1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d4f2e7be4deb5ce56b81c96cd61665a2c1a89aa41f146646e0843354ecfa091"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d11618c859905bf9c08d2875cd155ed9b1a5b29eef0f02aa69649bb6e488d25c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb97ea91b142fe4a1fd96f541feed4d7551661bab20e869baf65da15c7571ac3"
    sha256 cellar: :any,                 arm64_linux:       "c327411c522b94622a745bd840d9a053a8667365f009a06c1dda0248b10f1d29"
    sha256 cellar: :any,                 x86_64_linux:      "79207e4d9a44d78b4359523ccde84923f6609b6b0c1bfe11c16fe950b416a78e"
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