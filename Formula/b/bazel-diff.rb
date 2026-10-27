class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v67.0.1.tar.gz"
  sha256 "31216593e039e9d3e92e9f22cfe8bdfb136deefe7b17f09f61a777188d407cf7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a7ccbcbfd158cdf6b69491747738b6e8cb40579e94d15800e7501f268f0c7e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d58853f3a069bdd209d4ee5598f9e40413905e200487c0cbc4a44769ef955b8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc67b0e348394efe9667d8f67b23e16de301f5913fb08a77edc06343b626cae2"
    sha256 cellar: :any,                 arm64_linux:       "6b14b939caa0cac900683c6c2dd3927ea07cbc194b43f918d957a1fce4edb082"
    sha256 cellar: :any,                 x86_64_linux:      "4d8a6f84c7a497f3a2456722fa88b000904b42d2b4b263148b46f75e9764329d"
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