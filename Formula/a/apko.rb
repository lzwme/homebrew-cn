class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.8.tar.gz"
  sha256 "726498da7e1c62ec7994c8f16f0e837f5b85041203a07845242d7d1a317d56bc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc27f9fc3d780e76534f41d933df6e5f8628de907ed43e2fe7a7dacc079cbe0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f9517438aec50d424ef8020e5100d3fd992bb0af6198bb49fc0d990fb163dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41d7a95b5b828b0441334429b80f2b2e9faccb6a61b46346f145908bca3d2fcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "200cb4a77500bf0200d9ad0cd203222f7c967d7c4285eb974258d9a8345fd1d0"
    sha256 cellar: :any_skip_relocation, ventura:       "b1d8d688b57638da6d19f1e7a5b018455514a99733340031f91ac4eaa299864c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669df229126de74f914a1c71d6bd3df90282a0a2d3bd7b5bd790dc8611699eca"
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
          - alpine-base

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