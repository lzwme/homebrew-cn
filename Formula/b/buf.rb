class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.35.0.tar.gz"
  sha256 "e3c46be1bbe4e1c376f66cd923e004dcf69223112f61605815d4d1317972192b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f2f742c053db7c4bc7b3dbe7b86b89b9acef8d449cb90a94f09cf6f37ca5b05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09c16c69e8f4949c76080099acdd556c9f969ddd0295a18d5173d22023f5cf9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0279e28dbe9b21bd04168f18b0b4b557b2753e1630612c143a89dd206dc0c58"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b9df1f46810570da83651b232500e859bb44b9c4323e7d74f64c44c8aeb244a"
    sha256 cellar: :any_skip_relocation, ventura:        "f7e1596ea94a3b03079ae3bc16584e76a9db5555864736c4b7723dbded7bea4f"
    sha256 cellar: :any_skip_relocation, monterey:       "5cefbf2c07ff716d445cab7780827602a70df0127f539d08b32e471aedf5f911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "746731b4ffac64f8be0e26869d6deb4737d2976ffd84bf5a7fe6587c4f72aa3f"
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