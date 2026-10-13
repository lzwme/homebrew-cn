class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v50.1.0.tar.gz"
  sha256 "75c01ac32d6f0fd62e911dbcff4e507d358f7f5bfbaa3fcdce7838bfcd58e0cc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec9b2e2c7b1e46a1c92f9c12e5450c85f7361581739c50f031b5214993d5e32d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "698e41f3f9ff7fe74ed4d2b00a61cb32e1cf6642b7778abea6948a60892f908f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99416e44811478e009ea5896013967b0151a800cfefd4bac57417e82c3406409"
    sha256 cellar: :any,                 arm64_linux:       "fe25e5c6289428ddf1d6f8fb12350279894bb34c705ac2e3da6adcb00454e794"
    sha256 cellar: :any,                 x86_64_linux:      "5184139952e6c8f02c6e9b04a9fa14826cc2d46323c96470e8591a3d3f8c09e6"
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