class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.44.tar.gz"
  sha256 "1a85f27fba8be8746bcbb2e07aeb28ac521a570d86b4857516144e1bd208d9d9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5eb6920069a5e67cbcdf6e8c2e7fae6fe03765ecfe8f16819f3df99e283010f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5615b39c2c7108839329546ae4a0c3c134b1e1d86e96e5ddacec878da1489c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6177bf335338218c6b73c6fadb8c945ea773bc6caac1bff5c68767161f3f251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86710b313fbf5cdb57e084471ff5f09941cc39e949c30fd461a332a0ff698234"
    sha256 cellar: :any,                 x86_64_linux:  "3d6524696d2ab12ec9360bb7ea07f4afe87d82f1e560e60ccfd469008533f04f"
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