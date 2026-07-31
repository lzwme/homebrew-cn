class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.30.tar.gz"
  sha256 "4107b867f246ccdca56f9d65f270935f63f7fc1ddcb23f8447be124837725c41"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b618b545a555e334b8a9374897db097060fb9ac5ec30ec4855fc5c36933fb6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82644360b889f5e430948b1aa2cc69a23d4ca9361af5c755e9cfa383665b72cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf51aac4cac0ba4b1c6ad3f96791f85c278ea8fe40bf3cb406a5241829345fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "26d6987c4b15b540bd42d91fceb1122122bf1232908389a27f075212ba873979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69498c5808984b8f72517f51e2978db6b2574aa983f11ffcc276004fb92387ac"
    sha256 cellar: :any,                 x86_64_linux:  "0a43b8e487aad411446cb01439679db8a6b199d550611d565755022500fb6f68"
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