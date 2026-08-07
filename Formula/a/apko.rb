class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.35.tar.gz"
  sha256 "5dda8fc9b54e34edf6822876960c03971b3b8fd2c2f1b391ddc350b5066b8556"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcef49b4aac28869b024991884a2eb85c5930d48540df39227c16801ab10c958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34e835e32986673a2e9a82872cd8ce2be894f2645d975f06914991619e44f8c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a6b62b698637f16d5fbbe5945ae7e062e6e19f35af2449e7a384748c3ce5828"
    sha256 cellar: :any_skip_relocation, sonoma:        "5869bb40f0fbd3a4603b9d9d744250d79d777fd13ba41ddf30d6e45aaef703a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35575b7e3376cc057c887ddf24bf0dc348dd32ab4b5ded15bf8c96c0ccb1f00d"
    sha256 cellar: :any,                 x86_64_linux:  "3490484c79812a62b924c28aa022d6c83b8c58e6a217b438cb03bc4fd617293e"
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