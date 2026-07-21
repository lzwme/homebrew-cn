class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.27.tar.gz"
  sha256 "25afb6aa0191a4e86e61a7f31afe1a33891d852116e5c58100b22ddd299fde64"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc51ee7c491b25470c501247ff61f66fd14920ff4584cff1260cd14c2dab44f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ef62c03870681a8f8ec52d3bf7b14907e4e4cc26a2ed29bd9bf0e75a401471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee4195c98a203256a77d72bbdf91b0dd3ac601134ac0c71f01b11aca70cf7f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb115579cb60ed9d48351e6905dc8e18c48acee8a41f41bcb0dc0c1baede27fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ec260465dfa026a7d561853257bae85857544934c7be5e9238e652c2968b691"
    sha256 cellar: :any,                 x86_64_linux:  "961acbdda33dfad66cf8443dd0e2816091b630c0e40da98763269533a3f461a7"
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