class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.35.1.tar.gz"
  sha256 "a828948c59eabd4bdbab56bd78c491b8ad9a04d3062a1379073676f4fae84f62"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcdf60403f4054b792d54dd00b6cb8837a9311f17c6b980a9a1a593da9b80e47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ae07b6ca6e1bc37a6227269826bba14b205738dc03f21d36589b1952209ef67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d0675e6215ef5a568e7ed2cca7eb5444cce9fbfae9e97be58830d1c5720939"
    sha256 cellar: :any_skip_relocation, sonoma:         "859f02ebb98a46d995dffe6c1105c87160d679fc756e40967e40846d29aaf1e9"
    sha256 cellar: :any_skip_relocation, ventura:        "68fb8dfbd29438fa3ea621bc370499aba15c237dbaba1d028d990d834317317c"
    sha256 cellar: :any_skip_relocation, monterey:       "d641039e1232e5a6f0e52ba20aad0871babb2fb5b7abbb8ee8c085ffe21bb166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281195edcd11e8981900038b8ebd940415249437548795efd89a2d895cfc3ede"
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