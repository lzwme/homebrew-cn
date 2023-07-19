class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "5ccf081fad412c6f91fd22f69d7f814a315b8f93d7e99d76603a08c94b5632db"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "407e209016f254b00fd6b2a70e22da517bf223adf7852d8817994a3d1f3b0d3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "407e209016f254b00fd6b2a70e22da517bf223adf7852d8817994a3d1f3b0d3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70f9abd999e5ad2c318db33e9976991ae585501006b152aa72e9d0fd5ef7cf80"
    sha256 cellar: :any_skip_relocation, ventura:        "184dcb71265c7d014b6b55b99a87ecbf06d4e3ee05d5b7c53a693d193e5b54ce"
    sha256 cellar: :any_skip_relocation, monterey:       "184dcb71265c7d014b6b55b99a87ecbf06d4e3ee05d5b7c53a693d193e5b54ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "184dcb71265c7d014b6b55b99a87ecbf06d4e3ee05d5b7c53a693d193e5b54ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fca5d48e5e998f82adb068ea67a7e2b4bb32977d5aa602d75282c0aaf0c5c9b"
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