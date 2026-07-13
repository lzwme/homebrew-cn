class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.25.tar.gz"
  sha256 "826b28f50b8c52fa1ea14a6c5c43b51616109eb9e22ce59b70719f34bcc7631b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6205a9940f5ea201f5984a14fb1328213eaee3965575dee571b374bc6e0fabb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f36e43c49be64478a5f1b3e32232e4f67ad2b2616bc021bc5cd6f46f015e9c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b830d99cb9ca226d3bda6ac51324bfc9b905a8ca002567036eca0da4b55f05"
    sha256 cellar: :any_skip_relocation, sonoma:        "96149e927d564b47672ca6e482c05eeda3a2d7f6d76623a4fa763e2df312699e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cbbf03024ab9562b392af82045acb2aa3c03b47b42720dfacce75cc1e8c36a7"
    sha256 cellar: :any,                 x86_64_linux:  "f7919131c8963740516bb8bb62f3e6577d3700ab867467fd41276a465000940f"
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