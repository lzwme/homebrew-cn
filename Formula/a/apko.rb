class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.26.tar.gz"
  sha256 "c2de52d47a51f3169236a52abcedf4253cdda30b9a54da9dcde735708c8ce623"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0886fbd0e4d95c5d0515df0096c9fdea668a68196191b7892032eff4e58710c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a1f63fce2b9b8aafbd49ee11b0d77bab0bdbbbde6bf13c456bbf1b11b4b728b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34167d3adc9d5029d1486a7e6e8ba679e359a16ceb0e0ff01f06c77d1c0b441f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b24b872ec8367d3428e9ccb7918b9198a14748de29c1ffc08b579521c71f1a43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fa3cce49a46ecbff126987ad70ec22d96b4df14cbb4bc7a1c27454cd9f52b66"
    sha256 cellar: :any,                 x86_64_linux:  "d2b48eec2f6303ab1c86f66c7f29765adb8261c14fdd4099030b590e924a9086"
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