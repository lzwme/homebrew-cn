class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.8.10.tar.gz"
  sha256 "20a161dfc02b55c307dbf01aa051bd346d59e2106c9d23c0c37978bb3f16bc7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13489f284cdd2c506bb3b2b1922b969d416d6297ef1d9822a1967800492f674c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a703cf555e4f6de6283836be48e560f53acb7e56b8823b503f1f0e69c7c74288"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1fb5b9cc771fee0d337a73c4a755a7971c04f3b32a7e5ed46e46efeee6d088b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d802194c6d2568392bc9b92b31940f68077ca2296ee73839d2edf0bd09a1aeb0"
    sha256 cellar: :any_skip_relocation, ventura:       "e244e256203b1f492da1397f26036c6828b5980f48c39c507ba57d55b668a3c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04799fb8523e9d17fbde7f821d60754b4493c44eb9202f2c1d559ac17ce0a0e5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end