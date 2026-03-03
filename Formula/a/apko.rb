class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.12.tar.gz"
  sha256 "8933f3e1230b4a9e147e46c64d13a64d18d07bad561b42d81e92462d57de4020"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed344dd131850f3a4b70fb0149c61ecb0b821c03414b06629dc1b55d6cd70b4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab366f4589f738fd16e54d0354eb9d29022e5d05f063cbea1441636b96244c44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a96b8d55c05d9d7dc3796df65af85d6acec6a233ee7ba8d2212e8ad40a3afdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "488ce1cef2b58ba64dea7c78a414cb0ef7f411ae7142fb20b6554e4796ea5e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05aa2bcacc88787da44a4dd651db07e37e561985eaa579858e62b3f19097e8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9690fef8f024950cc1a2d5f8ca10a9201f9a313dac2f5975f61bbf4508fdab35"
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