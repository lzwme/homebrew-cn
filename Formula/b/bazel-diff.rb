class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v67.0.2.tar.gz"
  sha256 "3d9ea632672247f1bc60ab26be5bc41d9a3a6df4a0dc6e804b03940212666686"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "752f2f3c849e822f26354ebcf45c6c757b2bfd414b03a1181f8ebf21045e9535"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5293124e5149f618bd72998ff49c9cf1031b78669c4374807cc11e11aebde3ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da52f884b50e04cb2e64d8ffe2d004cf85632e5d15eaabc648c626eb682fe457"
    sha256 cellar: :any,                 arm64_linux:       "f1f8abb683477a11caf789f16a3a382d80424ddb7091a5d492fccfec3fae8e8d"
    sha256 cellar: :any,                 x86_64_linux:      "f6639928fc25a835bcec453867259e0fbe7321a850931983552d267a7958ec8a"
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