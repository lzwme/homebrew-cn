class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://ghproxy.com/https://github.com/bufbuild/buf/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "e67e0d8b1f6cf8c493d2aaa304075e5194456966c628404e743619db95297d92"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91a0922b19d905a2c12b2329155e22c84ae3aa38dbd6417971c9422dcec0ac98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91a0922b19d905a2c12b2329155e22c84ae3aa38dbd6417971c9422dcec0ac98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91a0922b19d905a2c12b2329155e22c84ae3aa38dbd6417971c9422dcec0ac98"
    sha256 cellar: :any_skip_relocation, ventura:        "071d311543e83aa661aefd42c039667cf7c1adb6038f58d2d06d2d72ec499e8e"
    sha256 cellar: :any_skip_relocation, monterey:       "09c9b1e6f779b08de0016448fc2928c8a1737456ea95b70c3eda5f55e9cf8011"
    sha256 cellar: :any_skip_relocation, big_sur:        "071d311543e83aa661aefd42c039667cf7c1adb6038f58d2d06d2d72ec499e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f311c41aa84e3523dbc488f0d0183800ad6361186ccadb6340a7e894c9a3ebaf"
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