class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.29.9.tar.gz"
  sha256 "4b29d8d329563cc848bad20d5ee4639ce6041fc5b6936f7b46b509f7d12881be"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e44c1fbf21288ec8c90ae5c778990ad03d951a6ab40d47b84401a243de4d9ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf7e0d29924b8ace41977eac9406775d0d1158ec1eaa3ee65debdaeef94c5e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52f0c75fac26f561a1d86922c51bacf7c244f11149a7347d9af9d0491a938821"
    sha256 cellar: :any_skip_relocation, sonoma:        "a38e054820803e241681862dc4f178569443a4d9eb300d05b9f27f65d1a82567"
    sha256 cellar: :any_skip_relocation, ventura:       "a64e48efc363e7bb31b58fc39974544c30bc9fc70872fc4f7cc3658ed14213df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a4de52033c04dbf58d65055981a850c40b14fa85fc28d0bfba6ba3cba9e91cb"
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

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end