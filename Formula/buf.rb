class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "cd4e6afd5c0de5f2be73f8f38ecce2657e980c055a889cc668aa4964005b16e1"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb74a072f0c650a0fee19c22f92d06b52dc3592887c2ec262820109d1f826024"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb74a072f0c650a0fee19c22f92d06b52dc3592887c2ec262820109d1f826024"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb74a072f0c650a0fee19c22f92d06b52dc3592887c2ec262820109d1f826024"
    sha256 cellar: :any_skip_relocation, ventura:        "7ccd07b0cb576a7ad449206ef66e0013e51ef29aa8697a7541ae6ed582090651"
    sha256 cellar: :any_skip_relocation, monterey:       "cc32d25efe2647b789c4a932a57d85a55ead7fa1b543053da97d83c0caa39f08"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ccd07b0cb576a7ad449206ef66e0013e51ef29aa8697a7541ae6ed582090651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b88ec373a0b84f75215920e9881cf7c3d2e8f0750a197329c3bf6e181028ff9"
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