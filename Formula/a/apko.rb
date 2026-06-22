class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.18.tar.gz"
  sha256 "aa5dcbdfe53d11ada923c25fc4d7f969571679e72e979e825d73805b74e2c806"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2851ecfc2985eee734264d4cc7e55bf086777bc35a0c47fca1293baa9869779"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee7da0d5e01039b4a080a7d1c1e0ade86b711980bd6bf909efeab44313152f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d734ebabf0b48d9d7d3fd7500bd0e8d7c1715495fcf6bb982083bda0c611dc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9224cbbbdf49dc3b59466fb4c8b93e6b1f5d3d9a7a189bd65fd086bec878659a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "351d7711e7fc585f39cc115ee237aec75f58c1f026869f5361a370f33cfc1566"
    sha256 cellar: :any,                 x86_64_linux:  "821b30fce4188d6749e5d4d44e21d6c15f3045e416d972c4633672c72331b7a4"
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