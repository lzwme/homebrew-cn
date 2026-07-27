class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.29.tar.gz"
  sha256 "6f433129deedb8fe64047c831e10e6e6a6a5825954fa7a095ff4f802f03dbfa0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0d2bd79be6ee5ee12d7fea30b679a3bf08813a77009b1ec3d927b82f4e4e329"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1be6a950b3c34c812005184868a7c51c850042906b3a7dfea9fd9f55b9cac135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04996442500197531961d10d281a898245c1abef00fdbf88cde52d8b653a7ecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8006dbdf76c39c779d2852aa339d5dd7216f69832762263ae83366aa17e6f591"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "191d9c8dbd69bc3f27fb51f747be6cd7cf8d9a186d489cbe9116f56d1bfdb685"
    sha256 cellar: :any,                 x86_64_linux:  "25a3d7458403d40567f7704084b8d0db17a87656217c72a46203da461ed8ddc2"
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