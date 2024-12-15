class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.22.2.tar.gz"
  sha256 "8b745848c3bc051fe44b294002513b015bdc9a3fb9da4f495e26fbf90326a8af"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8850485baa8f0b70bcf53929d143e7e70a2e0cf2c31abfcf55e2caec39d562ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8850485baa8f0b70bcf53929d143e7e70a2e0cf2c31abfcf55e2caec39d562ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8850485baa8f0b70bcf53929d143e7e70a2e0cf2c31abfcf55e2caec39d562ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a14516895eb2f6788b451e20687b1dcbc0d71a0deca98bca9a56b151a8d0c74"
    sha256 cellar: :any_skip_relocation, ventura:       "7a14516895eb2f6788b451e20687b1dcbc0d71a0deca98bca9a56b151a8d0c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d17e0f80ea426e4c0e5b0fdc3945242758ba8ca79a1d547feee09bbf46ca553"
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
    (testpath"test.yml").write <<~YAML
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

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin"apko", "build", testpath"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end