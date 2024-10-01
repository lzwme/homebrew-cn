class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.43.0.tar.gz"
  sha256 "08d2099a3fd90945228c68077bea101a67076170574f73e74f70b6025e2e02c0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b65837dedf0cc357b199c229e7e7c1df133b16621ff3859a6d7522b933ee6be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b65837dedf0cc357b199c229e7e7c1df133b16621ff3859a6d7522b933ee6be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b65837dedf0cc357b199c229e7e7c1df133b16621ff3859a6d7522b933ee6be"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8e36a93d173debbdcb4bd6cd79ffeb0fa2330d6758b2856af5fa78093791a01"
    sha256 cellar: :any_skip_relocation, ventura:       "b8e36a93d173debbdcb4bd6cd79ffeb0fa2330d6758b2856af5fa78093791a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "990dc3e1f041cd4640f63d1de8d944f141d1c479004f6e83f055369ccf7a6a68"
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