class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.46.1",
      revision: "94b3551a90144059ae5173fb9d6b7fa1c2785607"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4cb3e010a660bf18856919bebe95b960e99652560c44c3d807ddc7e41345259"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5ded9f626d8fcd8c25f1750e9c47232d7b762df9b85efe4b397ad9c59ef53a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9681da22609e0e6054103873f38ef1106e159e11bd633a8aee2e59c6fa6b5b3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4f2c7beed2f633b60ee2e62593ff3f6a05dfbda264d80ddb8c062547dbbf04a"
    sha256 cellar: :any_skip_relocation, ventura:        "0f8dbd29dcfe7964686e99f21b7820c5b5edc577c9b3dca0b82c3c38b8f0a713"
    sha256 cellar: :any_skip_relocation, monterey:       "ad056bd2ce30afa176b851667be7d50c199822f6ddb64e8144352f058702a090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9a126a63f7f9e695c643a58463c51331b5687b0f13a1c3fec9c4780cb232aff"
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