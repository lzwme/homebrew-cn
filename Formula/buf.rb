class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "5e4c4e6a985b622176988f1c9953a8b83a657ae22ee264d3354bac023918ca21"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16b105edac19d24ca572c912304df0100b9665c8f6982f0ad624c3c65bf0e420"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6ee2f0133f52d678a9e35e9ca855ea4a3e9521a510c2f175d580dba5a350fc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6ee2f0133f52d678a9e35e9ca855ea4a3e9521a510c2f175d580dba5a350fc2"
    sha256 cellar: :any_skip_relocation, ventura:        "cbbd559e494d8038c3d9be5375c633ea169a1da94806d87175426324cb399c5c"
    sha256 cellar: :any_skip_relocation, monterey:       "cbbd559e494d8038c3d9be5375c633ea169a1da94806d87175426324cb399c5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbbd559e494d8038c3d9be5375c633ea169a1da94806d87175426324cb399c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a357baf8779fad44a29ffd065791641326a0d71c0b1bef8981317dd7e952f0"
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