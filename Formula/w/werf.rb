class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.35.2.tar.gz"
  sha256 "26ed4f87a8aed71b275d6c2cf998721f337f1e59a4853224b5e279afc1893016"
  license "Apache-2.0"
  head "https:github.comwerfwerf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "105951c72c1c29181202cebaa33ce0fa8628ad8d9c29c50cd0eb7098d78ee415"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9df182ca2a733fc38b0af5ff837a6be6aa803a1b87b9bc4c5fe56ec045f84bcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f099eecbb89d4126b61d8084f2513cbb4d8dbf7a9f7476a8a2f856e64263b2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d49194398b5c56258782a87c08876916752d912ef9a8430e4e09771977b8e238"
    sha256 cellar: :any_skip_relocation, ventura:       "7d5ebe44994d121579699210a7b44c3d387cdfb230e660fa2501ad48e7039175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2428bbf9b2480f8bd260084f0308afdede1cb3ff635051d2185c450b0068ed26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fdea76bf06fed8a52153d02aba59ded75f9882852f69e7c0ff9185152e809dd"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.comwerfwerfv2pkgwerf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ]
    else
      ldflags = "-s -w -X github.comwerfwerfv2pkgwerf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), ".cmdwerf"

    generate_completions_from_executable(bin"werf", "completion")
  end

  test do
    werf_config = testpath"werf.yaml"
    werf_config.write <<~YAML
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    YAML

    output = <<~YAML
      - image: vote
      - image: result
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}werf config graph")

    assert_match version.to_s, shell_output("#{bin}werf version")
  end
end