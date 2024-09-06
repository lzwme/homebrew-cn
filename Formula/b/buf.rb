class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.40.0.tar.gz"
  sha256 "bc340f49b0000cd4869dcd1ff237256c9daa2cd5ea1120168090d994549e623e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd89e1df61aa96b12b02b68ad12853ac72dbff0e7252d3a33fcaf8eed5dbe972"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd89e1df61aa96b12b02b68ad12853ac72dbff0e7252d3a33fcaf8eed5dbe972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd89e1df61aa96b12b02b68ad12853ac72dbff0e7252d3a33fcaf8eed5dbe972"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b782d08a26de21733577a04815c039808fd1a9a342c9fd05e49280501343271"
    sha256 cellar: :any_skip_relocation, ventura:        "9b782d08a26de21733577a04815c039808fd1a9a342c9fd05e49280501343271"
    sha256 cellar: :any_skip_relocation, monterey:       "9b782d08a26de21733577a04815c039808fd1a9a342c9fd05e49280501343271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8d40da4d427b2e6e4139dd170b7bb66f150709f6d145abb20284b612314e8c0"
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