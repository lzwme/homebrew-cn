class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.29.tar.gz"
  sha256 "d065fd020036541f69b853cf115ff62c2b7fbfc50b103bd5a634596e29bb21aa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bebe3f296a0857fd8be566c2b127ada6891ed0fe698b6c4136cf81dcdd57248"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983b8f04ce9ddee123031dd49f65c1d639921eecf689c57280fc75aea3e93687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aba4ad83532b39aa5b2539712baeebb047a3dacb16842cb32c21b4fd5dc4992a"
    sha256 cellar: :any_skip_relocation, sonoma:        "aee62f1c76eed0802bc76371c76a1a8593d2f89c0ebf36af29971c973bd78091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e69dace3ca3c8d4fe49e5bf4471b54f4dbdb662a2cf31e948e28a130e3be441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3168f4e9b46abd1c2ffe1027feab3882005e55f952a027e84d477d8f9192216"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
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

    assert_match version.to_s, shell_output("#{bin}/apko version")
  end
end