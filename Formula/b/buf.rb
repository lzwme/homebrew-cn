class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.39.0.tar.gz"
  sha256 "8a3856cff8cdc1ffc4c8ae6dd8eec9c1f4a96a0a25e79574d76d8a2d7e3e9196"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4009e50840ca7bb2fa73edb10fe5e09379bf69e8ecc3c73e0db4994fb127e076"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4009e50840ca7bb2fa73edb10fe5e09379bf69e8ecc3c73e0db4994fb127e076"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4009e50840ca7bb2fa73edb10fe5e09379bf69e8ecc3c73e0db4994fb127e076"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d45dbbf93e676e248c50ce0c3940c39ece7a2ed5b4f33de47a3b80b100e318b"
    sha256 cellar: :any_skip_relocation, ventura:        "2d45dbbf93e676e248c50ce0c3940c39ece7a2ed5b4f33de47a3b80b100e318b"
    sha256 cellar: :any_skip_relocation, monterey:       "2d45dbbf93e676e248c50ce0c3940c39ece7a2ed5b4f33de47a3b80b100e318b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df437ebb8f55a5590e4e0706f6537937da97fa6e9776fab8de83952441a5ce7a"
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