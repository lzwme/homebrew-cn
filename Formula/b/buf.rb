class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.27.2.tar.gz"
  sha256 "6d03a41c43e1dae7d46fa357296e896cf00a8e52c76a1f1f586bad539ae451b5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eb055a1113e5f62b07096ad8e8a39e10dc62363171f579bd65ebcfcaaa5bac6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02458405d5d8b45a7e15b075e4e1bf2dfc7c809b3707671b41ed9ecaaa4ba544"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "989368d917c02039874f2dfb1c9fb9ba79432ea3b30e8b9ac1df0f65e01407ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "9483b4c43d15647b9261d157ffb1bd0d58ccca818bbe302fa7303cff28cffb4b"
    sha256 cellar: :any_skip_relocation, ventura:        "2d831c80db544c736e98948790786dc9afb1978f0a5f9313d87fcf8c0db8ec59"
    sha256 cellar: :any_skip_relocation, monterey:       "39a2f422ab34de80a3db5d517fdd320405ffa4a6e723f50f44e45f3b12d1055f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad6424fc039a47e40960576a35602ab9b356defc7643d573e72e470dc95d67b3"
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