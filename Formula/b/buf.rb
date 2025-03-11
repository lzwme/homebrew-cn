class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.50.1.tar.gz"
  sha256 "2dc0e7eae6a9cc206de4421162e0f5895b9488a1614b8bf30eebd5588cd08df5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89e19cfab3d75ca4597c3332d5e0fa35d63120d162160a30a628355ca632f77b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89e19cfab3d75ca4597c3332d5e0fa35d63120d162160a30a628355ca632f77b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89e19cfab3d75ca4597c3332d5e0fa35d63120d162160a30a628355ca632f77b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf9d266f70df737d8bbab6c19301e38c6e2828556a5bc5810575123dbd0c6255"
    sha256 cellar: :any_skip_relocation, ventura:       "cf9d266f70df737d8bbab6c19301e38c6e2828556a5bc5810575123dbd0c6255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c20c38964ab89d389cc1b9531083f859ca595f9762c3ab9f5d5da176de292e0"
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