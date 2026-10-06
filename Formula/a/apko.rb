class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "25e0606c0a367e65d91a31989bd5330ca6db836c9ec2c44af591cae7e1c7b7c9"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b094f0667090e9a0e9ec2c134a4b3107fbbe1167e82df52eb6d04b2f963ca72b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c4b6c19ebf6fb89494699fc37611f54d3707a059866a8b3b0c816ef2f4b46ef5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27eec3d886f436f47ca02834b42adc1f5d401b9c5006ab4028c3b422f1c9ffdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9edfdaa004a7bb9eadfa31b3f3dff139f703cfff07c0b6432a6bba850c9d4aa9"
    sha256 cellar: :any,                 x86_64_linux:      "c37e112f61cc979ee0f0898b8b5bfe5226d87c18bf7c0e5a22ca6ce6a4b849da"
  end

  depends_on "go" => :build

  # `test do` block queries Alpine package repositories
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", shell_parameter_format: :cobra)
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