class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghfast.top/https://github.com/bufbuild/buf/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "ab029136c76e87f69f0adfef9b376a64bc0b3f3d0c90743753b2938e086ad264"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6900b24472bbe331c18409ecc34bccc869e47ea7fc4242a3610419649076428c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6900b24472bbe331c18409ecc34bccc869e47ea7fc4242a3610419649076428c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6900b24472bbe331c18409ecc34bccc869e47ea7fc4242a3610419649076428c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eab7c7d625c5a8ffc1698d73788f068f92dc90ec6f0c3ed6df0ea241312d4c4"
    sha256 cellar: :any_skip_relocation, ventura:       "2eab7c7d625c5a8ffc1698d73788f068f92dc90ec6f0c3ed6df0ea241312d4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f1c6f0576fb06d5225ea3069fb922c55ff3c96a9bb8da97498c3797d4fcdc54"
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