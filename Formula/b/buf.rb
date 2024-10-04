class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.44.0.tar.gz"
  sha256 "95c2971e7d30f21e2351d6dfedb1ef58dbdf3676ff6f19dc1461307a5fa2b2f2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7cd9eb55bd2df0b8f478b035b3344f480a393bb283859a1bd72379c54c75e33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7cd9eb55bd2df0b8f478b035b3344f480a393bb283859a1bd72379c54c75e33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7cd9eb55bd2df0b8f478b035b3344f480a393bb283859a1bd72379c54c75e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "c342338c6613e7f7c71f50a6ce5978b115bb44a3f257b4402e31d6e5385a36a9"
    sha256 cellar: :any_skip_relocation, ventura:       "c342338c6613e7f7c71f50a6ce5978b115bb44a3f257b4402e31d6e5385a36a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a82663183e2d0ec49a8c7f40d519ae2b50e843b5f439c8cb2b3e775e1cd4fd64"
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
          - STANDARD
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