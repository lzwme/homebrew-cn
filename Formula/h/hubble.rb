class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https:github.comciliumhubble"
  url "https:github.comciliumhubblearchiverefstagsv1.16.1.tar.gz"
  sha256 "5412ba0a63b2a3b296643563dc3dd4a66dfafa727025119adbf915b5f24d7dd8"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0658f692d19e0ade0a5f2df39707967a8f0bf4cf8808aa1cf83425406d3f409d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0658f692d19e0ade0a5f2df39707967a8f0bf4cf8808aa1cf83425406d3f409d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0658f692d19e0ade0a5f2df39707967a8f0bf4cf8808aa1cf83425406d3f409d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0658f692d19e0ade0a5f2df39707967a8f0bf4cf8808aa1cf83425406d3f409d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1e42226fa13b0ca2c772b7b50fef406336a982d9f87a9c5b91a046fe469d75e"
    sha256 cellar: :any_skip_relocation, ventura:        "e1e42226fa13b0ca2c772b7b50fef406336a982d9f87a9c5b91a046fe469d75e"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e42226fa13b0ca2c772b7b50fef406336a982d9f87a9c5b91a046fe469d75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ecacfcc415915b36133c9a8c6ffc06a316d3b44a493fcbb55c3753a180bc6c3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumhubblepkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"hubble", "completion")
  end

  test do
    assert_match(tls-allow-insecure:, shell_output("#{bin}hubble config get"))
  end
end