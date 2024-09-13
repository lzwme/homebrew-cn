class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.41.0.tar.gz"
  sha256 "b9721906b0bfccffefe1d2c52e2b472dc212e40ff4be49c61d153132c3ce3371"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "00a2f110fea3f3a22c1680234f075e3b9a53489697f5bd67a89d7f9192710993"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00a2f110fea3f3a22c1680234f075e3b9a53489697f5bd67a89d7f9192710993"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00a2f110fea3f3a22c1680234f075e3b9a53489697f5bd67a89d7f9192710993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00a2f110fea3f3a22c1680234f075e3b9a53489697f5bd67a89d7f9192710993"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d3f1303ada8d4b9e6018a11f4ac5638f18b3662f14566839eae6c293e132356"
    sha256 cellar: :any_skip_relocation, ventura:        "7d3f1303ada8d4b9e6018a11f4ac5638f18b3662f14566839eae6c293e132356"
    sha256 cellar: :any_skip_relocation, monterey:       "7d3f1303ada8d4b9e6018a11f4ac5638f18b3662f14566839eae6c293e132356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d11d90cb320017626d524d0b9375aea57cff9121dbda7b522f3dee11a24cc54a"
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