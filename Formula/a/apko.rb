class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.27.0.tar.gz"
  sha256 "0bdce33ab49d034bd16b594ed6a531d7e41aebe178955705927499800ae2162a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "722bdcaa6159e7f3fe75733dede8f0b48c4fbedbb5d256ec11462191906d4421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "722bdcaa6159e7f3fe75733dede8f0b48c4fbedbb5d256ec11462191906d4421"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "722bdcaa6159e7f3fe75733dede8f0b48c4fbedbb5d256ec11462191906d4421"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b48393ff6fa511cf6b9f6d76396bf72f8f7e62f0b4b321bf3a363c1d17271c8"
    sha256 cellar: :any_skip_relocation, ventura:       "5b48393ff6fa511cf6b9f6d76396bf72f8f7e62f0b4b321bf3a363c1d17271c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afc74b6765a6bef32b56ffa3fd6b2bb5f3e4e6c39a0b5705dfbb018303dd96fd"
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
    assert_path_exists testpath"apko-alpine.tar"

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end