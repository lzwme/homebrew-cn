class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.49.0.tar.gz"
  sha256 "a67cc3d86aaa78f23099ec611d25d98e2de0c38b642408ef27d81f8fb12d8a09"
  license "Apache-2.0"
  head "https:github.combufbuildbuf.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f58969063ecc4d2bf5754ea2a65fc328984fe451004e30dfb36b63a7334103f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f58969063ecc4d2bf5754ea2a65fc328984fe451004e30dfb36b63a7334103f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f58969063ecc4d2bf5754ea2a65fc328984fe451004e30dfb36b63a7334103f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "22307b6adcb02b627372f7e8e7eedc82bc47107087dc4355247652852ddc65c1"
    sha256 cellar: :any_skip_relocation, ventura:       "22307b6adcb02b627372f7e8e7eedc82bc47107087dc4355247652852ddc65c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bbd8604804de9e87fef5a19064d8055d30b8b2b2b30d65adf46fc452e0f7450"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: binname), ".cmd#{name}"
    end

    generate_completions_from_executable(bin"buf", "completion")
    man1.mkpath
    system bin"buf", "manpages", man1
  end

  test do
    (testpath"invalidFileName.proto").write <<~PROTO
      syntax = "proto3";
      package examplepb;
    PROTO

    (testpath"buf.yaml").write <<~YAML
      version: v1
      name: buf.buildbufbuildbuf
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
    assert_equal expected, shell_output("#{bin}buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}buf --version")
  end
end