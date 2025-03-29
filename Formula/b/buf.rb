class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.51.0.tar.gz"
  sha256 "201b287802e3473cd0b8667f9049c02a0aac11eedaa1babcf9e6c37d9f4a2bf6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b766107e08c1f7ae7f48f2852c8df38c96d17f8fb14c3ddcfa415ba8449e05aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b766107e08c1f7ae7f48f2852c8df38c96d17f8fb14c3ddcfa415ba8449e05aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b766107e08c1f7ae7f48f2852c8df38c96d17f8fb14c3ddcfa415ba8449e05aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f676c01085fa64ce37707a36e13d939b6004feea5014ec0b2521f43d27158529"
    sha256 cellar: :any_skip_relocation, ventura:       "f676c01085fa64ce37707a36e13d939b6004feea5014ec0b2521f43d27158529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c08fbc80bd31eda5a949d4c44e52894a3dd999f139e162e1e090be3b1e24d172"
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
    (testpath"invalidFileName.proto").write <<~PROTO
      syntax = "proto3";
      package examplepb;
    PROTO

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