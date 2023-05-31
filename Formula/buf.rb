class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "7aee2bfc54e022fea9c884fbc58c1c39e52586087e8da7bb0f6034d37b625f60"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7361773e4bf0eda7608277e13b4e70c233ae9e52489ef047d319a6605e2d6671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7361773e4bf0eda7608277e13b4e70c233ae9e52489ef047d319a6605e2d6671"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7361773e4bf0eda7608277e13b4e70c233ae9e52489ef047d319a6605e2d6671"
    sha256 cellar: :any_skip_relocation, ventura:        "e7612c5616a245e68e9ad1b32638b63a46b81f61c1e463143e26752ba8d061c4"
    sha256 cellar: :any_skip_relocation, monterey:       "e7612c5616a245e68e9ad1b32638b63a46b81f61c1e463143e26752ba8d061c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3179553f58d3dec95b8921d0455d1adf418d28598f45452d84910bb09b4e0c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb5322ae826ed943a10f4323432b42031d4a49ba24f6e9b52a82100a0f1690f"
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