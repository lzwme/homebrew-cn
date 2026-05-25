class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.14.tar.gz"
  sha256 "c245051602f7b9ca3dc6fc766bd5f1891f8fc53da35165c03ee2330a7523efdf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8d20e3d4c463442cee81256727f552d2454f429cb448c4ea900ffd6705c1058"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14e2ae431d835cf9d538fbc490fd4289f3d0daf66f8f5930231f18a6169809d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80f75d623f56180ab73a010836ce8200167df640909b4ff552ca85f1b267dc35"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0cf411ecf18d8b6a9f2aec599349b3655e080700e78738030ce61bf93c511f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eb6a612178474d78187b6e1a46c61be52a9b6bc871b3b9224c7a5ef4be780bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5762af76e413d7dfa0a6486a4d77afe42fda14d1504e8286bc2fe36406ca5770"
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