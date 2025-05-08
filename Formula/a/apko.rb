class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.27.3.tar.gz"
  sha256 "aec5480a1006ccf3ce9c6e100d64d4b4dbffafaa4f2b9c1005762fb1a88a687e"
  license "Apache-2.0"
  head "https:github.comchainguard-devapko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c570f84adc1c972fe4ec3e29400923b79c986a315a333b62faea6e6dbe07f2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c570f84adc1c972fe4ec3e29400923b79c986a315a333b62faea6e6dbe07f2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c570f84adc1c972fe4ec3e29400923b79c986a315a333b62faea6e6dbe07f2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a1057e72dd1105c133b026e241db0e4ef11dda1d618786340923b17bc8db24e"
    sha256 cellar: :any_skip_relocation, ventura:       "1a1057e72dd1105c133b026e241db0e4ef11dda1d618786340923b17bc8db24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46d7247afa0fd4ae630c87588c8313d13b929e3fedd3b1150148ef787d98bbe2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.iorelease-utilsversion.gitVersion=#{version}
      -X sigs.k8s.iorelease-utilsversion.gitCommit=brew
      -X sigs.k8s.iorelease-utilsversion.gitTreeState=clean
      -X sigs.k8s.iorelease-utilsversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"apko", "completion")
  end

  test do
    (testpath"test.yml").write <<~YAML
      contents:
        repositories:
          - https:dl-cdn.alpinelinux.orgalpineedgemain
        packages:
          - alpine-base

      entrypoint:
        command: binsh -l

      # optional environment configuration
      environment:
        PATH: usrsbin:sbin:usrbin:bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin"apko", "build", testpath"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath"apko-alpine.tar"

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end