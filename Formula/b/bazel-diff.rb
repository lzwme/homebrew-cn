class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v67.0.3.tar.gz"
  sha256 "68a796d0a64c9bda3334585f574d5c486941e240f999b4b04c35f023f876be9f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02d952fa7cb2017eacb6b1c7e35a86b70cc852966b64a87ef03bfcf1e41f85b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42e7c580233c5d6c8cced739281a86b4e8f88d121b0f7f35412ec518ab32b098"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7a01232ac961f7358a5b2b4e88a368d99acc5624fbd4ad3dc1c54da6e3f7c6f"
    sha256 cellar: :any,                 arm64_linux:       "6665f890f7c525299813d6d13c47c250db5abbfc204cb32f6ec8377f62259cbc"
    sha256 cellar: :any,                 x86_64_linux:      "41376888e4b0e87084fe64381af7ecfccebdeeb29b3f669b67252ff6ae759e22"
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