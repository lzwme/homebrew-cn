class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.13.tar.gz"
  sha256 "120085477a56558cd89e3c1fd4bf07156a22bcfd0693fd097e0c3b3002b97887"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3921aa0ea039a7431c6cba95fedc0c51a9363d6b72ec35397877bf4fd2fab2b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6bde4a502e128456beb78c9209cc6250dd86d464b5338bc0a904a13fd36b31ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3fcc0bc26cc8cf0bda87f6ab87ffa45537c2f634bf12903a92df13014bab59a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1b277f2c2c93af3afe87f50b766f23581584051133506f4edfb2bb743985fb02"
    sha256 cellar: :any,                 x86_64_linux:      "05ad52055ea375c312cb786d721a87243d27d9ad539adcca72eb5ff66ca1c5d1"
  end

  depends_on "go" => :build

  # `test do` block queries Alpine package repositories
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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