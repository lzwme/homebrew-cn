class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghfast.top/https://github.com/bufbuild/buf/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "3b7dc788df0f59d693b4ade0d2447e647f90435a8adc1bfd111c346093c98b04"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75716788623c9a1c77378190f5ace7c72ae741e299dbf612b1857b1bba596443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75716788623c9a1c77378190f5ace7c72ae741e299dbf612b1857b1bba596443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75716788623c9a1c77378190f5ace7c72ae741e299dbf612b1857b1bba596443"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bc88b42f1462b215e1cfcb683f47e114eb35dc1100c82fc84184daa07713b5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175b2caf47b69b3c1c583ad20c8f91b12436211f6b0761d290ecd53d5a7f339e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1177b54ebab879c12090fe317ecfd85343e07b972e1c6d69798ae42fe1c1973b"
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