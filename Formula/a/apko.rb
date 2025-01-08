class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.22.5.tar.gz"
  sha256 "2d89201850e1b1d7fb63edb0bc6645211fb290dadcade31f4bc032c107bb8b1d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dda1e1fa18e8e4cc6db76ae3ee4b8c35f420154a35d12714f60639db4eba43a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dda1e1fa18e8e4cc6db76ae3ee4b8c35f420154a35d12714f60639db4eba43a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dda1e1fa18e8e4cc6db76ae3ee4b8c35f420154a35d12714f60639db4eba43a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c982cf76dda4b3a7ca5440548900da003fd5edad3b9bd374cbb2e3b6d3197ff"
    sha256 cellar: :any_skip_relocation, ventura:       "5c982cf76dda4b3a7ca5440548900da003fd5edad3b9bd374cbb2e3b6d3197ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71cff00364a51e20db39d50ed3f81fc2a67134358e7e87cfa8e0c2130509223e"
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