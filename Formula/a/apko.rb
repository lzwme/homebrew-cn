class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.17.tar.gz"
  sha256 "22010d4a2e35d8dfff8d88c52e4582a8d0c965bb0733d28deaef4666c483d4ed"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79abb41d8f81e1cbb56b486db6091ff7a63b814c8193d0de6bb379c9576f74cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "164d8fa031dd9dcf0bfb09d8dbf8704e7e00e7935de170e4d43b4f60f619f145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05794557d8c1170dfb56f5ef6b38893fde2dd3e44d115a941c221decedcd6bb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a409c0677d9ca56f897add4ce0a0dca7cf897dd57cb73c0a6bfca1fa3ae01f19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2484ae8f7b5c822263e3931e44c47130676557f7cfe932b490c7f1de45b64506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c70c6d6984f048e912fe21d8bd5d0c6592bf27f5d956b17fef36bf54e586ecff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - apk-tools

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output("#{bin}/apko version 2>&1")
  end
end