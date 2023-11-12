class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "ada475af0026bf25a36d4a7921b1d76e23d4a18123fb733d6b7f19390d47924b"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08f85168cc802adb253461348bfcc07b47e498f8725931558319344b165a7622"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b68eb78052d1177e81368abc5e9cb5fbfbd57cd2b2a1060fcf73462094ebc24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8129d4a365d606ee63bed4ae4a8939c11b3e7f575f9ca6c3f720b853ebca37b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b515e7d662e182c1dcc6b1e5fe56cb730377bbc080b30b869410056325227ca7"
    sha256 cellar: :any_skip_relocation, ventura:        "e192d4a78bce5e27678ff52fe8b47d92e9420c3a7af1f374fe70cce203f92db1"
    sha256 cellar: :any_skip_relocation, monterey:       "47e7e60abeffacfdc93377a9d598e81b316d4e38912a19bb8a160e157d09e286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb26ff116322c4debd6bacfa3c2775d32f2695dabb6f758555a93a159712316b"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", "completion")
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~EOS
      syntax = "proto3";
      package examplepb;
    EOS

    (testpath/"buf.yaml").write <<~EOS
      version: v1
      name: buf.build/bufbuild/buf
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
    assert_equal expected, shell_output("#{bin}/buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}/buf --version")
  end
end