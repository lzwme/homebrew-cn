class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.32.0.tar.gz"
  sha256 "f48f3640ffcaaf780aa372e8fa532d70fd3e3b626058f4f9bc1e210f3bfbc818"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ccb55fb346f82807c80b8830b9647161e4f9906c139e6e046bfd4014fd64c1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdc04e825a32f3478ded8422114a59a3b691394c2f498ca33e11250c4ca65635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b9b168565e02f96d61a5eacad5e68c740a15b4dac8f8467e625ce1a1b01abf"
    sha256 cellar: :any_skip_relocation, sonoma:         "664a8082861dae7d07c3acd2700dc1de2805fe11969b98cb40d504cb2617ad52"
    sha256 cellar: :any_skip_relocation, ventura:        "7a813c0695e84f235b934945307601b6ffec5cf767536ee555f87adc9928aaa3"
    sha256 cellar: :any_skip_relocation, monterey:       "99644b003403ca46e39a8469062ee32f5a600ce18c92a9c8ba3d33b2a5332cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fff5e719f804006144b23d479d05c169b58ce363e208c459e56531f1ef4e3d0"
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