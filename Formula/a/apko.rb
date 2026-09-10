class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0f9e882489b04b3a36b2c620ab4df6ae485dd84dbed3cab742d70b2b56655ef9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12e39d3639fb37851570afe09de84d07bc88dc70146d0e38ea23f36996791900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93c685c9333b130c2f9e1a88474d813d1d2cbc897f6b5bc94cecb21155e9bda1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "554093ba5ae521bf9983038306311c69c82d96b9cd1f3370af54c9b36543bcef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5efdc29772c5ed4654e9be61563063908496a7b0d0bab269ad5818afaed88f0"
    sha256 cellar: :any,                 x86_64_linux:  "8599af396faaf112b21d0c244835e0dd35d5357badb109b45688f6a61ef3353f"
  end

  depends_on "go" => :build

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