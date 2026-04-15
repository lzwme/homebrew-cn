class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghfast.top/https://github.com/bufbuild/buf/archive/refs/tags/v1.68.1.tar.gz"
  sha256 "5e3c34441d48314f3d72415ecf5c5ca7fb0d3bc54b405ade8bca034407bdd6f1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ebec7b345325e6b850f4679bee1f2a3c279bc470db1cfd990df8f7beda6b979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ebec7b345325e6b850f4679bee1f2a3c279bc470db1cfd990df8f7beda6b979"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ebec7b345325e6b850f4679bee1f2a3c279bc470db1cfd990df8f7beda6b979"
    sha256 cellar: :any_skip_relocation, sonoma:        "8755d53de16f7086aad8ebc476cd94bfc56c4686f010cef7c2698194fe02d288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6c409bfe978f51782bdcace623ab36f4ba55584ddcda2942d6de4c771c07651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d96eeea00372a3c165ddb32f39f032cb777a04b5537a6cfebfb8c97d2d7f434"
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