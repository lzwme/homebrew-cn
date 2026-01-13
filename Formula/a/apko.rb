class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "fe1e8ed32e470c5244e827e9d9aa40024896e13e487b0c5e836c9b9cc5b317d5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "526dd3eada06bf648e753ecce8383c0477c73dad2009fb1bdcef888610ab0736"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae52e47469c244dd30279b7897eafaf65571ad736e2f85f5dd76f5a303a64524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a2f7e76a30c1729b9a18d4339b16b3fcb0bc0ea7b20045f7f69da2a4cb39902"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cd220e9891e58821863c28d40e4506c54577e93124c1ea66480fe7138612121"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4852b56962112c8c7e03a528e5d687828a4dd18bd4f3e517dea81deaec31115b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ceb3212620a81389b2978f5520296e6714d711414284639ccdc29d59032112"
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