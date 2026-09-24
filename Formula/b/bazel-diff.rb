class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v49.1.0.tar.gz"
  sha256 "fc94acab65018d934839c92aef6abe362ef8e49afaa3bd93d3827ae4a0910be7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbbf6e570aa319493d2bfb20911c54ba5921caa9f7e96aa12a13ce065c7b8c3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a669bdfc265169a9fa1cb4c39357780348c28ca39d205d5d0f545fdf19d889f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be5c2b57ac4940694ef644a497319247e7bc35ee8e38e5de712bf43dc1fb2cf1"
    sha256 cellar: :any,                 arm64_linux:       "5fe98a19313bbc1684aa617862f074f5c84adb32b74316eed472c1f071b4217a"
    sha256 cellar: :any,                 x86_64_linux:      "caa1eb5305d12d6a24c0b3c58928b786381e36b01eb94b68d3e4011194598964"
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