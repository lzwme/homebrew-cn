class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "e1f145cbc8b807be314ed499b722d98e45f6553ee266df9065de9c658721366a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edfef3a9bcb6864eddbb92437eb2cb90b7c36d9ef37f50a48a8cc9cada9d0242"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f45f156970e808b664554dd3d87c54f83d8f941298b7fba9a5f1d15854075a75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78db99363f5d2cbb07d4ade703205e478dc66f89dd2df8bae09dd6168ff32702"
    sha256 cellar: :any_skip_relocation, sonoma:        "69a9082f4d111445d1bbf3b8db42381865ea3b3337f9de328557f59ffcde6a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e2d6eb80e4445db957e5ad11a6aba9a151ea30c2a879e36c277519cc01a37ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce3ead9f57eca0c3b30248a7914d35f2644cba1ee0df1d3b3242c2ac0e71e5cb"
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