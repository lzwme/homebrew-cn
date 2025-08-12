class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.4.tar.gz"
  sha256 "6d32c7e36f3d7e1f7daa563a282158ae44ac6fa1c977634edf5a8fb2dc50811b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59cbe725f50cd1dfa3f043ad0d4b0d96ef21bdb8f641f83b7b23fe23dddeccf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "833d5e26bf1264dd4b34cbb01f6a79c57cfc64869c075426417f0a87cc21d73e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3a16da7ad2c03e3275accbcd6e23c696b6d6cbb5f968a1ef6240c2b89a15cc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccffb9150d918069ea04f9e924cc763a84ceca011b76a1bd50f980810434e336"
    sha256 cellar: :any_skip_relocation, ventura:       "aca23160fcb2d9b086aa395a0248195d42310c2d7c5b246f2eefe5ec6abb1675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bc49c2432853939f1ba77c8065d5be3ec1ab05a0d2079558d53e43dffb45626"
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