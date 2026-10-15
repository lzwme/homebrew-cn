class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v50.2.0.tar.gz"
  sha256 "b6c8e66fc9e5c2803410bc7127331f42d43b1f40e50b88d1ef18b4217f532d21"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61fdf63ad03e024c2687759d07a3c469b2db11231951866fc81a04722d5255c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5008a1d2020fbb2aa6708573b226b765cb10b871923a651837183d26ba628cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd1d7aee9234eebaf919d6293e6fadaf8b891150e2fc569432940c26fc7602a7"
    sha256 cellar: :any,                 arm64_linux:       "e3562ad69d4d11a79b44076c33637ec205c1f389301a51bdf50b5a2666442cd9"
    sha256 cellar: :any,                 x86_64_linux:      "9e5e4f9c4d2c2ed71448d7b03bcdc62a291daf188ecc756ac44cde796c2b853f"
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