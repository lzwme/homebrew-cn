class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.14.tar.gz"
  sha256 "74c19f06ae3eb8a40011a7ac357f0fa904e9923e6984fe290546e29c5a5d49c8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ddca0a7fa77f588617343a2649e215079016d11a96c7660a0e31b89d754be15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3dec5e212efd5265a420319869d64d2b803ea5f03f69345d055871ef06f010d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b4d3fb005c50fc211658375b0c0d94529f468a45e7c0d0aa754c4b74a2a3738"
    sha256 cellar: :any_skip_relocation, sonoma:        "48163f71910f4f821cfeacb9ede2b7d92caa8569d7df0ffe06d449b5074eccbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9773aa8bf941ca372c326238fa6665d6febe7bb7244a6075b567e794e67cdd20"
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