class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "139ae651d9a01b8f27759f12c6f8c9e0578a71e5d6d09bfb63659bcbf5cac903"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c787cde5f798293bfc855649b425a3ed2cc9b4d5c1b147a84481b55bb0026da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c787cde5f798293bfc855649b425a3ed2cc9b4d5c1b147a84481b55bb0026da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9418b1456772b3e4adee140a05628ca2a69c6473ea6ee8647402d4153dea566f"
    sha256 cellar: :any_skip_relocation, ventura:        "f333c1abf594dffb6243de260191eaaaa8450ef7bff2958b5ae956e6a79be14b"
    sha256 cellar: :any_skip_relocation, monterey:       "b3db118e7ed84c5ad8f6915afc192b915cf452d4ef2bdd6f72e0d2c3f433560e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f333c1abf594dffb6243de260191eaaaa8450ef7bff2958b5ae956e6a79be14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b264c912ea3e626d608bcd89a89a3cfb335755461ee89ff2fb79a2b9ff53e0c9"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", "completion")
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~EOS
      syntax = "proto3";
      package examplepb;
    EOS

    (testpath/"buf.yaml").write <<~EOS
      version: v1
      name: buf.build/bufbuild/buf
      lint:
        use:
          - DEFAULT
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    EOS

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