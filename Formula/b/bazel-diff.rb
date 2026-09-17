class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v48.0.0.tar.gz"
  sha256 "a4c0c0f7a78266ec95716ae32b38e14a6035b105eb7779fa15d9b6310c10f2ba"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6e415eb47e987df248b3cee11208945a8f32d32d8073d877f377aecdbee4fdb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49df1086bb2289670381b040f809816529aafa78bc3f248bb1d7d0d5ec6d2b51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "221487511d2054752f618fa69113584759c2ff3cb80805848e4b9e358ee110f8"
    sha256 cellar: :any,                 arm64_linux:       "b7898f10d2ebe9ae9cb5e4f92aba95f25356719e4d9696a1e96d30ecf10b31c0"
    sha256 cellar: :any,                 x86_64_linux:      "617aefb72547857df3f281e85faa263eb65009ab1bd7d947d5cb7b90727cef19"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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