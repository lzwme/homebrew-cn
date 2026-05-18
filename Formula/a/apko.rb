class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.13.tar.gz"
  sha256 "4eac6affc12626f29699a425fc51ae3bb293f88cf39c5cb794ee298c1c5c674b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "832351bf72c50c601bb131e0d9f9daf27e6fd251f1c7821b9f81e4dbd2e74620"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0ad9d4a99d11331ba26eac10a761aafeb183926eefe7d76367e2a742bf90805"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb4ac409eb42fee09626c73a08b01acee38728faa43d96a7d8d5a814cb28b2a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c591b8bd7f2a27232a862dd457d8ae4e8c86c44c7e34c067cb7f6fc05f30c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4aa7a43c4d97e06264b9c98dd36bfa451ac5786c2056ad22a4d6378df6530b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be1362d96befc233abef3f2209d91e79b0801b4a27689bfae85d6588cab38d6"
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