class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.25.2.tar.gz"
  sha256 "84afde2ef3607f44df0a98aadb2d70e5633c06ac13d829fa38e6c05e522b3826"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62ab1e5336eb6e86d30391ad9e08a6ad33bea20dc097543a7ca022fb06e0e6d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ab1e5336eb6e86d30391ad9e08a6ad33bea20dc097543a7ca022fb06e0e6d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62ab1e5336eb6e86d30391ad9e08a6ad33bea20dc097543a7ca022fb06e0e6d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "55a985e6a50eb1d69ee635b36520ad4ace68381a53e3e36a59e8b2475e9fad7d"
    sha256 cellar: :any_skip_relocation, ventura:       "55a985e6a50eb1d69ee635b36520ad4ace68381a53e3e36a59e8b2475e9fad7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ccedd2a05c78bf84996d6e06275fa53e988cf43ba3de0b68fb1fb6d015c2f6"
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