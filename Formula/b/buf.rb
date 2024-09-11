class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.40.1.tar.gz"
  sha256 "843a2eeadac212b145e653d492f55305974308347027ab45e1d178103f278168"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a9ef1316096146fa3e8b1693db99e72b9d3fc8f8e0fcd25ac0d8cdd942adaf2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9ef1316096146fa3e8b1693db99e72b9d3fc8f8e0fcd25ac0d8cdd942adaf2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9ef1316096146fa3e8b1693db99e72b9d3fc8f8e0fcd25ac0d8cdd942adaf2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9ef1316096146fa3e8b1693db99e72b9d3fc8f8e0fcd25ac0d8cdd942adaf2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "10984b090afcbec007af9a433b35337754b3177ec47758e9c221b62173046713"
    sha256 cellar: :any_skip_relocation, ventura:        "10984b090afcbec007af9a433b35337754b3177ec47758e9c221b62173046713"
    sha256 cellar: :any_skip_relocation, monterey:       "10984b090afcbec007af9a433b35337754b3177ec47758e9c221b62173046713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7c1a4ffa5ce2726b02a4fe9faafae0a3f5cbd9f3aa2515ba6bf662badb1421"
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