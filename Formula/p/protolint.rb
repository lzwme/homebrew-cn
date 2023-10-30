class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.46.3",
      revision: "6bd312ad6d1e9f650d340250759f3445cc57d23c"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad055f370b92b3697972e879cedb4edc2009fecf05c31c9fda73d4251c1afb4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f89155cb7c6e45c1beeb56f586e73e765bda3bd4c8b759b2f3b9fd3b33a5090a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79c3c352ce0033d2f8a723a83d5567df2a53e2781b3a0f3f7e1bb32cbfa7bf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9626baace5adc174ed31fc66053081f9437fb760ee7dc4428e7735c21d1d544"
    sha256 cellar: :any_skip_relocation, ventura:        "2a0ae7f12653de5e424cc5b721ed5c2c7e6bce3464b12d40a6e4eb03b329ac42"
    sha256 cellar: :any_skip_relocation, monterey:       "f61db50f97e510be8f2be55e6be11b6378caa01bfea78d1012a4b90a191c2a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7500716e2ac1a670308be72f2f3cd253fe10defbc16a592f52b0cb400d42c6ff"
  end

  depends_on "go" => :build

  def install
    protolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd.revision=#{Utils.git_head(length: 8)}
    ]
    protocgenprotolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.revision=#{Utils.git_head(length: 8)}
    ]
    system "go", "build", *std_go_args(ldflags: protolint_ldflags), "./cmd/protolint"
    system "go", "build",
      *std_go_args(ldflags: protocgenprotolint_ldflags, output: bin/"protoc-gen-protolint"),
      "./cmd/protoc-gen-protolint"

    pkgshare.install Dir["_example/proto/*.proto"]
  end

  test do
    cp_r Dir[pkgshare/"*.proto"], testpath

    output = "[invalidFileName.proto:1:1] File name \"invalidFileName.proto\" " \
             "should be lower_snake_case.proto like \"invalid_file_name.proto\"."
    assert_equal output,
      shell_output("#{bin}/protolint lint #{testpath}/invalidFileName.proto 2>&1", 1).chomp

    output = "Quoted string should be \"other.proto\" but was 'other.proto'."
    assert_match output, shell_output("#{bin}/protolint lint #{testpath}/simple.proto 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/protolint version")
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-protolint version")
  end
end