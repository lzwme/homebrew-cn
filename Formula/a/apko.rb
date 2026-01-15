class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "d9af6e2752dfce788e0069d45ae8ec75e88670bcb3c76f154cdb951cdf9cc64f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "596f9d1cfcb1a5899bd5f28a5a78c5ee14e91e6489698dd1159febadb4d76214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a67538eb523f6ceb56b6243f6f0a9c2bd7e2ec8d44b6b4b18363def5fe8e29e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ad35b8c8b0167f60d1e3fe0190240fb676029d396ad8041f0dc695c25df2ce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "364ad299c5fbfc93a65a92a3dc42add38a9b81b9ddf813d635d760306c6b4b07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d14232d0dded6ef9349bc8d50f4f443342d3adb0e4e072b0ddcd314862ce532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f723b6f7a315e530a2818b00daa71e699c9b7167ac37005af3db37936ee5959"
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