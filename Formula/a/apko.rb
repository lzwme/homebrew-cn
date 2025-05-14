class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.27.6.tar.gz"
  sha256 "19339f3063a383b0128f3d9cf8db2542c244f6331cdcfd6b255d8dead0977572"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a3ff35f5314526d46db5a91e940254a50d91d9de9f639665f6b15954302122f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a3ff35f5314526d46db5a91e940254a50d91d9de9f639665f6b15954302122f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a3ff35f5314526d46db5a91e940254a50d91d9de9f639665f6b15954302122f"
    sha256 cellar: :any_skip_relocation, sonoma:        "06aa47c2e0f39da8048593bcc6a0379db0b30584514d63ecf671242813069b5d"
    sha256 cellar: :any_skip_relocation, ventura:       "06aa47c2e0f39da8048593bcc6a0379db0b30584514d63ecf671242813069b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "563cc122af84609074adc2a889aa70e7100b0a40c0dd256bb705081f3f44ac9d"
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