class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.28.0.tar.gz"
  sha256 "bd1658a120f88479f54678c5ae69e73fbd2ab8594ef47116a8c58181aa69f081"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daaee7745e704bd45b668af575fe7f65453d993a4a97ba2adf482e405648a941"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daaee7745e704bd45b668af575fe7f65453d993a4a97ba2adf482e405648a941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daaee7745e704bd45b668af575fe7f65453d993a4a97ba2adf482e405648a941"
    sha256 cellar: :any_skip_relocation, sonoma:        "6366329d80b82ab82bd3cbae22e5a4f95f22c56c738e9de379b00d4b83e7a92d"
    sha256 cellar: :any_skip_relocation, ventura:       "6366329d80b82ab82bd3cbae22e5a4f95f22c56c738e9de379b00d4b83e7a92d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c675407ddc583f9bd83833f55bffee7a6d960269cbc051118cb7e7e4817712c"
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