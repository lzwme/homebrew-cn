class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://github.com/yoheimuta/protolint.git",
      tag:      "v0.45.1",
      revision: "a207f60c29ad5a022186a473f484b01aa23dc346"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dff779ecd0d9a52b22d50740e76e59e76814c003dd77628708752699ba40668"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dff779ecd0d9a52b22d50740e76e59e76814c003dd77628708752699ba40668"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dff779ecd0d9a52b22d50740e76e59e76814c003dd77628708752699ba40668"
    sha256 cellar: :any_skip_relocation, ventura:        "23890721bb13be41166138d465b70f74ae0c39b14dd73a78daa9ac4ed1316fbf"
    sha256 cellar: :any_skip_relocation, monterey:       "23890721bb13be41166138d465b70f74ae0c39b14dd73a78daa9ac4ed1316fbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "23890721bb13be41166138d465b70f74ae0c39b14dd73a78daa9ac4ed1316fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d36ebd9294d8b307dd168d23533cfc8433b75f00d8f4df02c5e12ce9ebabf13"
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