class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.36.0.tar.gz"
  sha256 "baf83670022ab32d606507720a33d337ab5f41e4c9e89f540c664d535edb5140"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e91a028448b4c508dfcc37e99359e44f5bbac5010b63cdeaaf544af949227e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13d2fe319a97f0026d296fa967db83180101da000192fcd55885d71e146bbbc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26f670392ad660aff53bc5cbd8669f5f638915b255019e98c2c99aee71bfb043"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e5d1ceaef4d2348e60f8b316c6091287fac0472a2f82664a70f9c272d5f84e9"
    sha256 cellar: :any_skip_relocation, ventura:        "40013179f2d264f674219fe4b688d59e2db07d3e4eabb01a4055a7e8de2be8bb"
    sha256 cellar: :any_skip_relocation, monterey:       "6464452c58d43195cccc9240d96894b9f69cba4e2b4967948b166e3ff627ee21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e2b1debf195bd44db3c4ce11254d6549360f48da1d7f71ee9a984e70ced048d"
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