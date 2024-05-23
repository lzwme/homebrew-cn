class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.32.1.tar.gz"
  sha256 "15b8750b1184d01672ecad4cbfbd39254244605fcddc304c88bbcdda20276892"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e5b41fb06e8ee9f84635c062afda754fe1cc2b2330f8759e2377014bbc6bd50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45cb89d7ede595886b2a505cc58d74cedff9998c5f39ee2ec9a7ae165e68e2ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a14559b0f62e4f7657e99c8a3d359028ff32775d30d81a98d6570336b6b01d33"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4412fae5da6ceadb1e80b47b846f83d2e7cbda1871f89c8793663bff2f16106"
    sha256 cellar: :any_skip_relocation, ventura:        "f8c620c762da312ec35989f670a345e62c40d33ca7c88e80bd181f1e1b1808fb"
    sha256 cellar: :any_skip_relocation, monterey:       "eaf5623c7008c6d7c30217353af1b42640293ee8d3255b8df34832b6075fdc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8eb87972530ea1120a5a412b02b9aa46b15040b583208b3414282cc67e998a4"
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