class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://ghfast.top/https://github.com/cue-lang/cue/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "adf74a28a010456a50941a556011aed5ad9063d5685bd43183ca278e66acb65e"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6205930c02a1ce05f3e717c949095995b9b0270bb88fd4242c859f014caae015"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6205930c02a1ce05f3e717c949095995b9b0270bb88fd4242c859f014caae015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6205930c02a1ce05f3e717c949095995b9b0270bb88fd4242c859f014caae015"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a7e4becd18d7d9bfa6675746a5fba7d82c328d0c06771633041e5f4aec9d0fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05042470c80912f63cf48a9082675f1cb36ca838d32f4196ad7c5d0bc4ce2dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe4c9314cf82f87861849389b2a2cc6866611f26fc267e447bc792c0c29d3b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.org/go/cmd/cue/cmd.version=v#{version}"), "./cmd/cue"

    generate_completions_from_executable(bin/"cue", "completion")
  end

  test do
    (testpath/"ranges.yml").write <<~YAML
      min: 5
      max: 10
      ---
      min: 10
      max: 5
    YAML

    (testpath/"check.cue").write <<~CUE
      min?: *0 | number    // 0 if undefined
      max?: number & >min  // must be strictly greater than min if defined.
    CUE

    expected = <<~EOS
      max: invalid value 5 (out of bound >10):
          ./check.cue:2:16
          ./ranges.yml:5:6
    EOS

    assert_equal expected, shell_output("#{bin}/cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/cue version")
  end
end