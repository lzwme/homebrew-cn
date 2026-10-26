class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v67.0.0.tar.gz"
  sha256 "6cd6fb7aa52aaf00b7f0ee9a28cee219650143bc23a144501dcf805e8a75daa1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d144993bbbd61dd6153285824ba688e8f024de2c2c1d567a2d00dc9467c547c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b217307d1336771cb206cc77c92ecbe395892ac7e058f3dd1d432a1c18a6536"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2023ddcdf1d308ec42c48f5925cba34a103e29816666bb8c4093360ef305ee53"
    sha256 cellar: :any,                 arm64_linux:       "6a2e1f58567453ed35a27aaa2a1efd0213ec48d0fea53b2d2508ab62093ace0b"
    sha256 cellar: :any,                 x86_64_linux:      "2317f5ab48f27a48b77c05b78615796c3660288d312587d38b506bb956dba721"
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