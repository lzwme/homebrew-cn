class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.33.tar.gz"
  sha256 "28a2f9bfac8cc1558ca942bb2ffe0a6b22f25568a5bb161f352be25a2572e453"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae5012a3e8450bc19a845d2512a82848597dd746e3887d471f39206277ae0227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f372d92cea4bddea02ccef35216a5deff777cfe5a7aa6613890d904ae4e4b75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3a3f9d3f055aa9996f2be86024eacf49e8f9adb77342d715225bb187ddd7173"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdcdac58b2492e30a11a7f63f3f20e4677f3fcac89344e5f5a2ba657e692ef04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f21e051778eecf07b1c832927de721412af2bc413c7dcbe9bf33cc08c89f7c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b97cd3328dbc5fd3b7f2c5f4b949caf3eedea36f4c7bde331bb9683b49c51dd1"
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

    generate_completions_from_executable(bin/"apko", "completion")
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