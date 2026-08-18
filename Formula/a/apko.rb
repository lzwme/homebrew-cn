class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.37.tar.gz"
  sha256 "a88161691be7f07df73417194867dc0c5dbd079126b46540284bba5de2dcc2a5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "262346f5c4a2e0b67e85bbe4da4596347b2ccb32e62294b038eb4ab5d3977308"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7254a60d59b5c38cd9757d3ed3d8dd22804994a2b0f69060961bc64e2156d114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9da2eaffdc771e2523d71758dfbfc1680a29d862a8377dac928e80379bd4be6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "72dd6b146c4400e1db740bec4da693237b8be53a9b5b3c5360fddbab2c1d4cd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a70bca2fc0425f32dbfabb57cc31bc4655eba68879a2b5be52bb7f7114387390"
    sha256 cellar: :any,                 x86_64_linux:  "a56eae29d88b024275ae6e5996826b8af502212d1e2d303cc1e1defd145d3915"
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