class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.13.tar.gz"
  sha256 "a753c94f98dd86aa74f4ab11d6f18f8b8b39260ed18409c0835449da86b67e1a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61b214dc5c47619404dd526fa30b55963d9ea0e6930a7f6f5b0251b29ec4067c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e3b6681b11858b479cb3f6fdf01f1b1aeab616d9e8cc1543846fa0df4cb01bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b21715b983593b1351af4d4bbffe24f1e336cf84f9cecbe006392d17539532d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3e2537276fc59375f989d78b4e8a3228b4194951a678df0186e0f5462ce422d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "552b33b7adcda6e40e697789b352cc7dfb8f1535846e1ed12432c443275ed666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "799885a759b2f1989a53013fedeeca04ed80f3471e0f834bf2cdb3f2f2a31c7a"
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