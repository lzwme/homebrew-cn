class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghfast.top/https://github.com/bufbuild/buf/archive/refs/tags/v1.62.1.tar.gz"
  sha256 "9f4221484f622ed657c103651f29ca448d0d8ddff72fa1b35b14b8a3e02bb1b5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc9768398d76126019abfcdb32ddd377282d4ee9aaeada3d2039a9c6ac71b7ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc9768398d76126019abfcdb32ddd377282d4ee9aaeada3d2039a9c6ac71b7ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc9768398d76126019abfcdb32ddd377282d4ee9aaeada3d2039a9c6ac71b7ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "eba7e7f101ebca0cfe727d84165514e7fa95fa1438d594a7533f43648aa5f29f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de2fd2b551365354584aafcdccffc30866d2750243cbabd107ce54191c678c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b775f881e5b91fe4f8c1700301849bacdf6e1edb4b3245dd7169d3051aa58714"
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