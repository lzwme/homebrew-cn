class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.25.4.tar.gz"
  sha256 "64f981d2e3e87b5343cee09384cf7f0152e76cfa0b3c088ac09d0ee902e5b16a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2080dacc1899a46f13303535c1923eb1d3e4898c221c2285b102a959d6535bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2080dacc1899a46f13303535c1923eb1d3e4898c221c2285b102a959d6535bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2080dacc1899a46f13303535c1923eb1d3e4898c221c2285b102a959d6535bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b649db9d63be402bc0aca7d77335a23edfb2304a23d3c837bde069ae5efd928e"
    sha256 cellar: :any_skip_relocation, ventura:       "b649db9d63be402bc0aca7d77335a23edfb2304a23d3c837bde069ae5efd928e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0722ea865bdf4b6f9b5ba73b6404e740e662ef37412ca10abac003fe52cb97e"
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