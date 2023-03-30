class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "813622b436554ee587c25da4c43b2f0277cc8638ee1a00c46c0bdfced57b09e4"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8888ff245831959703e9e17ab545e8009e0aec57c16807bf37f75871e99d3624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8888ff245831959703e9e17ab545e8009e0aec57c16807bf37f75871e99d3624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbc1b2b964b3d3122f04b7611d3886e64afea6f5b2fe81cc82c4eecab551ebc6"
    sha256 cellar: :any_skip_relocation, ventura:        "e7d645685bed4db0213165452dee9c786e910293abf22944371a58aeb292f920"
    sha256 cellar: :any_skip_relocation, monterey:       "53c70b04c1adf93da6aec4d61512ea5909b78be6f19d67b6dc5cc03138a2534a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7d645685bed4db0213165452dee9c786e910293abf22944371a58aeb292f920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f145554cb57fc1221499c1b526701a79f11ed6ae42f09a08c71f40d34b26fc"
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