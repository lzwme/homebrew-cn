class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v61.0.0.tar.gz"
  sha256 "d34f8c3c8c168062fa8f5b0a2902cc08916206e265fcf7cbd3f40d98451796b6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b43de4b894df6f79d4217f9acb3705c5b48d2bc99314bf183d6cae8a1ca24ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f772294c508106db0b2fd183d02edb5796027c0f1bbbbb6088e869d2fae52ec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b66018ae93b5c49acd24db33dbbcf274a9c5a554b83ee8d22608746fec5b822"
    sha256 cellar: :any,                 arm64_linux:       "aa54cb2705f71545a492ab70c48e0b3d8e513784f02b830436f96bc64fae1a18"
    sha256 cellar: :any,                 x86_64_linux:      "5beba8dd10167a2f33582794cea982f2dc8511cb44ea7cf16e03b5663eb98907"
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