class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "8fdba8280c9cdbe5d69133f7a83be3142777fd4d533f16d84af361c5c26339bb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fab87425aa3c8b15fd70c9854d80e4b933092dc5d843ad7b09337b8c4d14d440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4283d6de6f2166ba6704fc8118774818eefc2250471fba25e8b31ba0a727998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9b19e6114b9f024f0746bc2d091db0ce07929dd23aa8327b7d37d6358afe548"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bdd668c30ec05662c0233a30d0dfcc4511216d506b37f682b626de410d0f745"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88ad3612aef7797e36ff1a5917ce868cf39b21719237893b06e93a53e58da511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b66206054fb6f3ea23df0caaa543ebc1e4c0f5bdf1100f6d2172c01e8d7a61"
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