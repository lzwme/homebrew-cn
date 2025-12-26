class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghfast.top/https://github.com/bufbuild/buf/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "97459176763e09f55311fd99b38f097c8782d4a4abb0eb1e853092220547ecb6"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cab22e1e5fafd35be9e4b60a1e56005c119e54ee081faf4bcffc505f8fe5764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cab22e1e5fafd35be9e4b60a1e56005c119e54ee081faf4bcffc505f8fe5764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cab22e1e5fafd35be9e4b60a1e56005c119e54ee081faf4bcffc505f8fe5764"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5f74e3ebcd384d9ba089f0fb1171354e9fafc1a157c5bb4f159ff520e99f3cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "915f3ef85a3be05299d352d7a2350d03c6d3a38db981fed24cb9b99bc83be59f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a08d5c7b621bfcbcf665c687e5dff4c73ab56e61714af33aa37972df0bc5e3d7"
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