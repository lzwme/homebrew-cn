class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.42.2",
      revision: "1a05b7f50c01dfa0e0991ae7e66eeb8ef0f607db"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2ef4c851f1dc91fac09f9710bcce7f1579938a32d633dc29defc49a3dafe047"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f30160d5d36c07be1f201f257daf5feceb94d2fd3202ea4cf4c88dcd7ee3182"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f258eb00cc5aba88e0d32600eae18aed9be1553339bbbd2b266108666506fb16"
    sha256 cellar: :any_skip_relocation, ventura:        "f3022e3e5a0bd0f16ccf3644442d447decb598ede2d23fe08f64674a945d5329"
    sha256 cellar: :any_skip_relocation, monterey:       "11f647aed64d69b8dda61d2f3ba82d67a2705b61e33219761e01c40daf0b5d73"
    sha256 cellar: :any_skip_relocation, big_sur:        "211c303c740817ac6a9eeb494c386920b6a03fa6b00b27c452d38bbff5e8e809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93aff754379c171066cc05567a22211d13e5f8d6883a83418a4bd1ab57a1365"
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