class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v68.0.0.tar.gz"
  sha256 "16be40f50e42d962d82e3942b455750f6abb84fdf65b94711737a959c54a4fd9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82fd93fcb2edc631ee58b603f400262db607a63bba23f4528a0fc60d7ee8c8d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "297cdb824839574e55378ccbfbf6feb01c875bb92a28cbeff8e24876c8cc8963"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ddf1b613ac9304cc4d7bb131219c9e439da3a4d111e175fd23cb255084561cf6"
    sha256 cellar: :any,                 arm64_linux:       "312ba64f37ab826faca3365891fd2cbab8d458fcc1a1933c8a4a1f17fa98524b"
    sha256 cellar: :any,                 x86_64_linux:      "243dd840a48bcafd34db96c7470df87a57a2215f5060a2f351bae48af758d5a1"
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