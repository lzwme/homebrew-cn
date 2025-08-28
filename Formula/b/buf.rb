class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghfast.top/https://github.com/bufbuild/buf/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "9d3cde708b61190dc8906bd590c0fec2587aac43bba0dfc561a917bee8207bc8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45d24ce7cddc71352b742fad2579041b71cb1942e1c2624312ebe9fb0d7d9ae3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45d24ce7cddc71352b742fad2579041b71cb1942e1c2624312ebe9fb0d7d9ae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45d24ce7cddc71352b742fad2579041b71cb1942e1c2624312ebe9fb0d7d9ae3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c702d47b64399cad8a87d9f2eac29c0b3f29133f3a0890cb92b4cbe27f08f4f4"
    sha256 cellar: :any_skip_relocation, ventura:       "c702d47b64399cad8a87d9f2eac29c0b3f29133f3a0890cb92b4cbe27f08f4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2d0c1ca8d7d7b93b6a6e9791b93187f5b042869cc8d08a0f9dab757430f4249"
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