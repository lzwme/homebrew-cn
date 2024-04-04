class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.30.1.tar.gz"
  sha256 "56da0c31b11bd15b99049af8b364c7bf4e11106152ab27d5ccb98d28123ab785"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d542d18000df7f4608401fad6495cd4eaa9e132457dfa31de5977191c57311a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "913fab7b7ce5661b3c14b1e335f310125572cff4d86d2bb82cfba16afe79dfbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8451b56ec50a6f56ec4859c0c587cccc23c91d20d4129f5ee6a2bd45d7ac0406"
    sha256 cellar: :any_skip_relocation, sonoma:         "cca7a0b6f7fcf47c0489f65d3e6994090d3e2395183efb429ee9c3d4f169a243"
    sha256 cellar: :any_skip_relocation, ventura:        "c526619524be772d5aad675132e4dd77b66ae33f9cee3b21a4ed79c991db2c8d"
    sha256 cellar: :any_skip_relocation, monterey:       "49c7ffb0e82fea50f662b4db7c3efaed4a92120dc848d965449045af4dd8d2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9466f135989e8983ae84a0713a46973091d216d54f73e9a024fde7582c150349"
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