class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.34.0.tar.gz"
  sha256 "a0c67af6db7ae2313297732ad57daa35acf96229bd2ab6494155db3fe5219287"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "796de9ba54eeda45fcf1fbf519c781b4634fffec7e6848a2443f21a6257398bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f347e28e952621254e5100c7d379d174162a9a579563cc6e654b161eceb56bcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f26ab0719d51acdf90396dd206b6d19bf7732924fd702c0c07920b6bff5b795"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bafa0c611eb6677b4fcb5ae651465325d06eaf364a4c6a8a0efcd928e0a9698"
    sha256 cellar: :any_skip_relocation, ventura:        "c546534ba39a52253392502ec2fd1a31c4bae816ffdfd039747a8696130ffa1f"
    sha256 cellar: :any_skip_relocation, monterey:       "de198feb3099feb087cf1031ef6946c341f070492e00099273783e847f5e051e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e3ed08bb79c213b59fc8d96318a59ee59285e742261285c1449feeeb5086bd5"
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