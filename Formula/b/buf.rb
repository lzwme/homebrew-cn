class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.52.0.tar.gz"
  sha256 "1cc28f42bf89b192c48342b3762026415a0f6c530b9cc1829710a829a24701d2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a5bbcb4bea2f2bc7cbb398328912fde45167127e0681bcd2e34904c9182167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52a5bbcb4bea2f2bc7cbb398328912fde45167127e0681bcd2e34904c9182167"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52a5bbcb4bea2f2bc7cbb398328912fde45167127e0681bcd2e34904c9182167"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdae07ddd90efbe3fac25f296d3262d08e182ddcba331cb45316753310faf1ca"
    sha256 cellar: :any_skip_relocation, ventura:       "bdae07ddd90efbe3fac25f296d3262d08e182ddcba331cb45316753310faf1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fed707c0a3b0f44584b69944887d3c55e8999cb2e287664039c681ae82e2efc"
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