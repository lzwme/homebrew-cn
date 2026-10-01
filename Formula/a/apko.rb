class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "375d9157074af74e4700f302f695f75cb4a9597fce23a575a4940e8efc8512e8"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "943cbda0675a78a75784fae24be964e7b44863f82d2987cb3c78fc99446e848c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd583248f815efedaff068c8efa318f635e894ef5a0d241bacdd0f6985b7782c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c75e40195dcb1da83eeaa3974559f50b5775f2a9d50768f079e397df020f0aee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfe064ef13608c2d76c7968530ce58756d7dd8beaf16e245d8f1f3dcc3b64e01"
    sha256 cellar: :any,                 x86_64_linux:      "1d7c7652d7b67165f59afc887dcb319134ee3d30021953cd3073aaaee921d139"
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