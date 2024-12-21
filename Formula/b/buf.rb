class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.48.0.tar.gz"
  sha256 "cff797352d237e69dd04372fb284e1162eb65db812e8de86946968418a146221"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe0859281515f9d431a1ea639a8688de259c4416b8214b13375b2341103b46f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe0859281515f9d431a1ea639a8688de259c4416b8214b13375b2341103b46f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe0859281515f9d431a1ea639a8688de259c4416b8214b13375b2341103b46f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9eabc4f2470707be5661dff885ba8a82f0039bb27fc9f9c7f45b45239d162c9"
    sha256 cellar: :any_skip_relocation, ventura:       "e9eabc4f2470707be5661dff885ba8a82f0039bb27fc9f9c7f45b45239d162c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7230f574956cd8763fdf4671b2e23149a9639a5be3336354c8cb81adad617771"
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