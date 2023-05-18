class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "e3cf1521222902d13b4e72f8dcd2f63ec04790324e288b650de6276a0edc7836"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af418d9d50fb51d4ae749a71b81ad4d0887c6cf0dd3d9189e679bcceab1ff7b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af418d9d50fb51d4ae749a71b81ad4d0887c6cf0dd3d9189e679bcceab1ff7b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "361e1d33c6e08e1296f91bba339e4fb746fadd1421536df5626813ac2488661e"
    sha256 cellar: :any_skip_relocation, ventura:        "b0c756a471598fe39347648edc39e7f09e97eac0d16c04fe20d11db16ab92aa2"
    sha256 cellar: :any_skip_relocation, monterey:       "132be700eaa8d5f9c27f4a5c67171126f6c8f28798e57c7ff5e0410a03851c5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "132be700eaa8d5f9c27f4a5c67171126f6c8f28798e57c7ff5e0410a03851c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9da70fbe7080dcbb971a4be43e369fc11660646ca8db05238b3967b42bdb2e4d"
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