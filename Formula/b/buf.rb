class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "4ccc872e26edffaa99baa43d7091dcff50347bb8132a57b97880385d7742c82d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3d996b33480545432b9a4740d717dba53c251b02fd933de6f052c63f8ba2958"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ec1ce10c00a0d84988adfbd7f4a834980e856992c3c2507240b2d4603b5ce7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "384ff1d7c95eb5fa99a102bb4e0d193312bf1cc7f58d35b19d9aac06ba70bad5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d7310b0135cc42509d50f35a1c6a8d4d9c4d2f367f7b9089d20d0464f028ac8"
    sha256 cellar: :any_skip_relocation, ventura:        "17ee586dbd182655133339eb489c4a28d062df4bb7347b48b7882e38bf32abc5"
    sha256 cellar: :any_skip_relocation, monterey:       "c8a8b1fa3ef78edc8cf690720b9e4b43b0a88b29dcd2b8183aefb65ce73d0d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "925d56efe5a89d8c34238dd42401c8e40a5917d09614f25bf2c5ded8eb9b3316"
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