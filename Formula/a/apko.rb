class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.34.tar.gz"
  sha256 "187df2902552a3587d9990057240f7a4eb8452418cef7d09c31021fabae1bcd3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c867e2de2a6c6cdf870eb7e894960ae2c96f8802827897e4252f916f1dc9761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ea658128a6f18143c2702bd36b6f3c1b03e0f7e744a55affe093235f4206af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be706d4aa5be5403cac381f6f83ebc176fc8b898015478fca1651cbc0a9ca434"
    sha256 cellar: :any_skip_relocation, sonoma:        "6742e67de24044c48a80d32cd513759c0ff41c0d5b9f8b8b40d545cd15ab3409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c16384d0e8af31c34bc89be4688294a5d3f05d2392695d9f6ed384e6adc0d48"
    sha256 cellar: :any,                 x86_64_linux:  "aa38ce9bd073788ac70345bdea419a51c1226e8b2684636d68eac69c55414c11"
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