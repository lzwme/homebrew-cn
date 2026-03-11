class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.14.tar.gz"
  sha256 "60e7d222ee33e6c481c8d7071c395c49e161a1a967d04911bc3b4550f694b182"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "400ccd2c8ade5a1c6f019b35a86e222394e934c95b9e2889b056e04498bd359a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48ed3b059320ea08fecb9c2fc67fe60ca8cc8e13659c3bbb1bfd7ce3a1ac1832"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8ce97b22409c6d2edc461033e41c725b3a649055cd630dda5e5fa7e801546a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "49c3e4c07c40e3682abe69433d1de1b93834424cf0a292fa2cba7197de1d0e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eab0a8a68c3800dd28155dc1c3822063873759669becbd88ff742336aef9506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb4f59ec9e95865544780c460feab055033e48e08fc1f740758065995a19a921"
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