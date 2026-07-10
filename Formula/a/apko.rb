class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.24.tar.gz"
  sha256 "5ea9c30d2ecf53b309a002b5cc57e5eefa85b022b592666741f038c3ec3af541"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a764ff51c7dd1e8af8da11c6848a4c870d9f78c93a86f2d33ee2993bde1b94be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa6f0a065adb367319a510148c5f9373fd3f5a9f6b155afd078611dd7d1b5a1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4b2bf0630aef4fda454c0e0b07664a1f54962eb9eb52970f92a68184dfdf296"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ae570922d854599c371b366a5925549f95c1eb43279d3fd2df6e0a958c93743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07619cbc4ccfed8f0351cfa4dda4a929923a740a4c899fcbd8c1fd1bdca0526c"
    sha256 cellar: :any,                 x86_64_linux:  "e3fc3a903dcd70c5641d1d90ef6888d04800feac7643b3f699ca8446c6ec0bcf"
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