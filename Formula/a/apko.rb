class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.19.3.tar.gz"
  sha256 "4c7afbbc1877bbf18efc8c999c383600584edfd6f93a88dd714c81fafc49103f"
  license "Apache-2.0"
  head "https:github.comchainguard-devapko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f800880a373f2b7cea7582837433e8f1d3edc7bf2b0d4a37fb4eba53caf1620e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f800880a373f2b7cea7582837433e8f1d3edc7bf2b0d4a37fb4eba53caf1620e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f800880a373f2b7cea7582837433e8f1d3edc7bf2b0d4a37fb4eba53caf1620e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d5474d717f6322a972214b1862439892a8d8d5472f026b9d0ac3a50bb92dc1a"
    sha256 cellar: :any_skip_relocation, ventura:       "2d5474d717f6322a972214b1862439892a8d8d5472f026b9d0ac3a50bb92dc1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5de2e2972ed13f7d355d76d55453f62bd289c7e50b377402d8efaff6eb285639"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.iorelease-utilsversion.gitVersion=#{version}
      -X sigs.k8s.iorelease-utilsversion.gitCommit=brew
      -X sigs.k8s.iorelease-utilsversion.gitTreeState=clean
      -X sigs.k8s.iorelease-utilsversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"apko", "completion")
  end

  test do
    (testpath"test.yml").write <<~EOS
      contents:
        repositories:
          - https:dl-cdn.alpinelinux.orgalpineedgemain
        packages:
          - alpine-base

      entrypoint:
        command: binsh -l

      # optional environment configuration
      environment:
        PATH: usrsbin:sbin:usrbin:bin

      # no keys found for arch loongarch64 and releases [edge],
      # so constraint the archs to x86_64 and aarch64
      archs:
        - x86_64
        - aarch64
    EOS
    system bin"apko", "build", testpath"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end