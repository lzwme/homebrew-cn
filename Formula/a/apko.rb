class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.10.tar.gz"
  sha256 "6cb4e44c8ed495e3251cfca8861a83ea768481e2efc69fa013239e8b9e338b82"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a11cb3b2b494fdcd6d111f17812801e5e03c1748f405c8f2cead940bac86499a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09396785418ed53061d86c01d070757cba78f36e4fc2f4a1c7ad7f3fa2beb6dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d95361b9ffcf734e2f49e829615fee8a44971416b1e503a0a894faa94fc67d1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "94aaa4530552ddeb55c22e0197c21faab63f80343b1b7945367c9362e48e0019"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e38ccd282036021cecea40e7fe8620966fbed8307e19de30c49f6e5dc702230b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "673d1633419d19841d9d6890c95b7ab8656b898772c36073d392a5be02f107c8"
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