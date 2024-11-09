class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.46.0.tar.gz"
  sha256 "0a45975205fe8ac0eea6673dff6b86603eaadbc8ce6dd62bc95dd925ab6d2419"
  license "Apache-2.0"
  head "https:github.combufbuildbuf.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13cc3b194458218761f2066413960ea37dcda0f1b4a20942e2a63a7bf87dd1dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13cc3b194458218761f2066413960ea37dcda0f1b4a20942e2a63a7bf87dd1dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13cc3b194458218761f2066413960ea37dcda0f1b4a20942e2a63a7bf87dd1dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5eadecd9654542cd8de72f84c95a929e30532c36db849a9a956b59b6b5a7491"
    sha256 cellar: :any_skip_relocation, ventura:       "d5eadecd9654542cd8de72f84c95a929e30532c36db849a9a956b59b6b5a7491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d3ec92d70208efe9628feb464df1fc68cdea5110f5ee796745cf90820d5eaac"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: binname), ".cmd#{name}"
    end

    generate_completions_from_executable(bin"buf", "completion")
    man1.mkpath
    system bin"buf", "manpages", man1
  end

  test do
    (testpath"invalidFileName.proto").write <<~EOS
      syntax = "proto3";
      package examplepb;
    EOS

    (testpath"buf.yaml").write <<~YAML
      version: v1
      name: buf.buildbufbuildbuf
      lint:
        use:
          - STANDARD
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    YAML

    expected = <<~EOS
      invalidFileName.proto:1:1:Filename "invalidFileName.proto" should be \
      lower_snake_case.proto, such as "invalid_file_name.proto".
      invalidFileName.proto:2:1:Files with package "examplepb" must be within \
      a directory "examplepb" relative to root but were in directory ".".
      invalidFileName.proto:2:1:Package name "examplepb" should be suffixed \
      with a correctly formed version, such as "examplepb.v1".
    EOS
    assert_equal expected, shell_output("#{bin}buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}buf --version")
  end
end