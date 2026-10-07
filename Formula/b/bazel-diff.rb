class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v50.0.0.tar.gz"
  sha256 "70c57ec2e27418848a269360a4b69a93b0a88f717bee75d9a463adda86c147c9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a3896a2ab3456ee4ddfec9c7fd1c43cd1a5fb24272acae03255da9b86295796"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ce951700d1cce29b3acae2f230fbd1a6b030940aceecf962631ef16ecf4470b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e75242215d6ee7f93f8571aa460e7a07e85fd76108f6a43f0d615545084717d8"
    sha256 cellar: :any,                 arm64_linux:       "9177b0a98c512923bed81ef279d2cbfb4362a1a93292ede461be9844fb3960fe"
    sha256 cellar: :any,                 x86_64_linux:      "23be9fcd68516d2f3928919b7f43ceef54c23c96a40162bf0266bdaf1ba868c1"
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