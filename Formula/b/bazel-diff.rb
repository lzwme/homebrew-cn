class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v65.0.0.tar.gz"
  sha256 "4285990a67cc9b7d4363a81e480422e58d6d65785a02454bb1033d98feb29510"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e5a887c1cf902fd610245e38eed75e7b28b8557c001c4a7b1f66e2e336481d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abd569b19f7ab0fb9b8050daeacf694c4e482370237e863a8c94490bdbf0af96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca592beb1cd0893db4a9cab0a0884d4557a8866deace8d030d193373daeae7f1"
    sha256 cellar: :any,                 arm64_linux:       "3ae7c9047ee933c7b3512d70faa337f1684279634de96b56365948379efe8507"
    sha256 cellar: :any,                 x86_64_linux:      "41b96751176b6a4128a11352de182912a5f8a92910ff21cef4e3df8f2c23da79"
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