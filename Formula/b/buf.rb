class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.32.2.tar.gz"
  sha256 "876c91cca6c2e647d6cad231d51bf95d525f17bcc7bc8920a36b9bace016af96"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6128cc178ad406ecc4fcd129d3d8a64748fbd719fefc445b3fd400d6def4a06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2290a6e6082003a6d96c5be965780c7657e1bb0ac4aa64a0fb05eb50f2a0cfb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2844e6b07366eee728ae4006ed53808186387b10592086e24b99f8965e9a9a10"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3f3b6b8ae8b84cf3a7a89c972bc67ab4764880eaf1ecc9ca8ced916176399b7"
    sha256 cellar: :any_skip_relocation, ventura:        "55c06e2c0f789b2ebff75709ab959d37a5ebc7d1bfdc3b2fb2621fa17b9982b5"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd5f0a8936d7dac5a79be44a3d788c9be0e1528779f85c0c7c3de23efa6e7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "313094dd7525e2e4b52f1fce7b64df4e8f327c6123d2b0103d13197dceab8532"
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
    (testpath"invalidFileName.proto").write <<~EOS
      syntax = "proto3";
      package examplepb;
    EOS

    (testpath"buf.yaml").write <<~EOS
      version: v1
      name: buf.buildbufbuildbuf
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
    assert_equal expected, shell_output("#{bin}buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}buf --version")
  end
end