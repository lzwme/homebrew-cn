class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.35.tar.gz"
  sha256 "01bd925294ff3f62b4b558721e7217eea01bdfe801c64789957676ddf7c3eb59"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1bd37331a8d81ef39d1a87442f4e8d1c8b941bf7388ed9d3b969d1d9ea22086"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaeab7ec4cc2dfd0b7a7ebe15e67b173717454ca4daa864d30c0c648c143da45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbce37f807df8a107898ddf7baba812da8471b9c506ddbcaf56550506d351823"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cbd28ceeabd5392817f26b728443f5c2ac139f85046780ed6bfa77c4abd2bd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "644abaf178018d139700e858ca9040f26700cce39974c1bd5140f357c5d39fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ccba95fb6afa1493203c5dff9d332fe018d1cf8b8cef9c1758abd016bdb6ea5"
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