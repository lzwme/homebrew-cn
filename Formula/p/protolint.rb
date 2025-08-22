class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https://github.com/yoheimuta/protolint"
  url "https://ghfast.top/https://github.com/yoheimuta/protolint/archive/refs/tags/v0.56.3.tar.gz"
  sha256 "cdd411da0285a0c855f1ba4b1e8fbf7660f2fc9c3cd5bc4256c5c6e15b9a6d22"
  license "MIT"
  head "https://github.com/yoheimuta/protolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4a0ced891f65afece2df8e25cd6f64f704fc951df75a0adadf9b7ed7306344a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4a0ced891f65afece2df8e25cd6f64f704fc951df75a0adadf9b7ed7306344a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4a0ced891f65afece2df8e25cd6f64f704fc951df75a0adadf9b7ed7306344a"
    sha256 cellar: :any_skip_relocation, sonoma:        "87a74e430558106dd392f0409f46b2ec5f076f98f69dfc9a344aae7b8fa2ebd2"
    sha256 cellar: :any_skip_relocation, ventura:       "87a74e430558106dd392f0409f46b2ec5f076f98f69dfc9a344aae7b8fa2ebd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae8f990c836bf2194cc8bb7b7f2f1254fbb2f096b83788f1de0615ba416d263b"
  end

  depends_on "go" => :build

  def install
    protolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd.revision=#{tap.user}
    ]
    protocgenprotolint_ldflags = %W[
      -s -w
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.version=#{version}
      -X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.revision=#{tap.user}
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