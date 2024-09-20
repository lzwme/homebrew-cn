class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https:github.combufbuildbuf"
  url "https:github.combufbuildbufarchiverefstagsv1.42.0.tar.gz"
  sha256 "825e9004703c6817bd1bd2925004d2e22e55359c6c5e30cc748dc09637b0e59b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e10e46a7ba7a565dbe5d3000c4361032e580222399b7fb8f417121b1ea35f72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e10e46a7ba7a565dbe5d3000c4361032e580222399b7fb8f417121b1ea35f72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e10e46a7ba7a565dbe5d3000c4361032e580222399b7fb8f417121b1ea35f72"
    sha256 cellar: :any_skip_relocation, sonoma:        "67fcc3cafbed12b3af2d7578c5c4cb81ea95062a494efb54454b56dd5e098241"
    sha256 cellar: :any_skip_relocation, ventura:       "67fcc3cafbed12b3af2d7578c5c4cb81ea95062a494efb54454b56dd5e098241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "999bf5583d4b636117f9a3da906b5d03483ced025872d7839233036e9c19418f"
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
          - STANDARD
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