class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.24.tar.gz"
  sha256 "c76798c5ddbf071c4ddd38ff23f2c6a22c177d41c3d5d6532ebbd409dc150d2e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b98d3a484602df3ae8b6529259028d6cf9010d839a9549357604a3d00375507c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb326c50321a06f2ee4db618bd413dd45d70eb6765bbe704939756b2dab216f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9beb3d31e69c6170fa7138c0efa823cfeac2ef54e486ccf48e6f6bff89796a7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a943cfc70b9bfe67f79d4178f2e54ea2915f1ce66066ab54d4a6dddab99c82bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cd44eb3d0060fa82d66c829fad5a49ac94bd6a179390c44d1134d08f2f002d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa8d59b35f630dd80f3e3b6a2ffbe88b36f003cb67a48decc80d92285d34518"
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