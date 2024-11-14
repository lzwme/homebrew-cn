class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.47.0.tar.gz"
  sha256 "c4f27c1648172c7bed2f716f8d3b022a0f16b1ef7d62165ef0e055f670513ee2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3235de1fe98db40a48cd7857fc29fcd7ab08e93c406f561ada2e6236e8fe6a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3235de1fe98db40a48cd7857fc29fcd7ab08e93c406f561ada2e6236e8fe6a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3235de1fe98db40a48cd7857fc29fcd7ab08e93c406f561ada2e6236e8fe6a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "478c5322955dc0527e7fa765054adcd1a7bb2045058dca14643e895b07012a3c"
    sha256 cellar: :any_skip_relocation, ventura:       "478c5322955dc0527e7fa765054adcd1a7bb2045058dca14643e895b07012a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6768bed08633e204266c81500d9a5e91805660f500be95163455fdb8399cceea"
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