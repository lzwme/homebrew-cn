class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghfast.top/https://github.com/bufbuild/buf/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "afbe924144f3c229a1167a82e805a481f5def88cd31071e4ef7e812daeb06e27"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0920066a1d4a6c1e8a0decd394bf4c397a8e72b9d020fbb422faf7fe1a3c500"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0920066a1d4a6c1e8a0decd394bf4c397a8e72b9d020fbb422faf7fe1a3c500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0920066a1d4a6c1e8a0decd394bf4c397a8e72b9d020fbb422faf7fe1a3c500"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a64f672475aa6ecded31c64f51539dd4c0f935f9eb8ea006afc627a1297a7ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5fdfa4f4e4cd165935df8b093541c8329478239716cd565db73fa623d6a26c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8dfb20e9067737fe0f7b09ec5c8a0c498778732440e8117901c28dfe28146ea"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", shell_parameter_format: :cobra)
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~PROTO
      syntax = "proto3";
      package examplepb;
    PROTO

    (testpath/"buf.yaml").write <<~YAML
      version: v1
      name: buf.build/bufbuild/buf
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
    assert_equal expected, shell_output("#{bin}/buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}/buf --version")
  end
end