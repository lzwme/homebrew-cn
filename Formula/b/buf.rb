class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghfast.top/https://github.com/bufbuild/buf/archive/refs/tags/v1.68.2.tar.gz"
  sha256 "bfeef71f5d23bc4f69b8a26e05d4eb967169e540bd3f0e536471debf715c45c0"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3079e592a333a3c73302c9a2384d08ec53794cab316959635a5cb2e8d7a5676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3079e592a333a3c73302c9a2384d08ec53794cab316959635a5cb2e8d7a5676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3079e592a333a3c73302c9a2384d08ec53794cab316959635a5cb2e8d7a5676"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a59338722f9f5e4140ebbd56cbf16bc2a036060a914afb7b3b57d7c1e8d188e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da85a614354a490b937cd709a20b544ec0a6c8ccdfaa87a8da8bdf1b2a734732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "216cd96c10eaf48780cb0767e074b1885734d9a7dd36fdecc3bdb619b01367c5"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", shell_parameter_format: :cobra)
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~PROTO
      syntax = "proto3";
      package examplepb;
    PROTO

    (testpath/"buf.yaml").write <<~YAML
      version: v1
      name: buf.build/bufbuild/buf
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
    assert_equal expected, shell_output("#{bin}/buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}/buf --version")
  end
end