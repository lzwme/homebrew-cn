class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.16.tar.gz"
  sha256 "675f176a9ae6090a164a00c7785c033ef7d821f063295baf096e5c91f4c62f92"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e304c13802c24816b704f3bf6ec3a8ee590cae10084605e2ad51e48352a93cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eac791be7bb9d1f1eadfff00e57dcd792583fa2d7192129939037e35091893a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c1b547148f2cc1d9b443648763fae98052e59d7625d666a32a99ed89bad6a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae2ae57ab787f07306a600cbf648abef3d69aa21c68146e4dc65b85a46deaffa"
    sha256 cellar: :any_skip_relocation, ventura:        "ac06b6b147858f5bd27fd320ef94359ba453725abc2bead78bd709a624ee30ce"
    sha256 cellar: :any_skip_relocation, monterey:       "f160f019f85fb9ef15ce3d80e1b2938d8e163670bba4a4b56626a4b8d832157e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b1f8e804de8a365e58a58c3a6377f6c12b3ac3a08196492cc1d458a3afaa19a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkubescapekubescapev3corecautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kubescape", "completion")
  end

  test do
    manifest = "https:raw.githubusercontent.comGoogleCloudPlatformmicroservices-demomainreleasekubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}kubescape version")
  end
end