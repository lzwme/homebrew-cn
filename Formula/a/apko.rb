class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.31.tar.gz"
  sha256 "59f32cdd928947eabf95ce40bf2f995d6fc04a2094ee33b4fa0bec717aca35a6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a1ee7a669b9648b02997bb16b1247baac9cfd773a6ab574113f8b29983aef1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f79d6498cdf9d4724b9223102117f699f1dfdf4d4bbd5ceceed41a19ce75c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59bdcf2ff28c3e8bca5c2bd3e6c3b0e1722c3c974032a9e6d9af24458cac2126"
    sha256 cellar: :any_skip_relocation, sonoma:        "2982bccce9a83f7f553cf7e8e0d279fe4ab518176b17ab006fc186e1a8def43e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dd7d2fe2ca1db8538bf2f63e606f5eea9f32652ca653a9587f66c822a3f15df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c12d9c8e5e418f2deca18275192a6b61b23bc73f25e2d470f7f34b8085c109"
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