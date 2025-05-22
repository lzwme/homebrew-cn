class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.27.7.tar.gz"
  sha256 "f487a11826bc7ac06044c0a3e7eddb5ad52568c7088affd11d6be526258449f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "026fbd743a101fef9ca8b26d6ba79d56803f1057c43f4a067c035078a7ac34f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "026fbd743a101fef9ca8b26d6ba79d56803f1057c43f4a067c035078a7ac34f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "026fbd743a101fef9ca8b26d6ba79d56803f1057c43f4a067c035078a7ac34f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "af88b0807fdacceccca655e29ae0f911db534b09bcbb8a4640c7363f4998f3e5"
    sha256 cellar: :any_skip_relocation, ventura:       "af88b0807fdacceccca655e29ae0f911db534b09bcbb8a4640c7363f4998f3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751e2c53ff92f01922878bc39738b91c4581406ca9b46b9bf239f52fbcb7b7d9"
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