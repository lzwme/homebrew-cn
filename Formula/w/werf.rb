class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.35.8.tar.gz"
  sha256 "6d67b5eb7f011dac78a840fc32fb6775ee08aa73f5806f1ffc82555cbc2762a6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d8d6d72a58d3cc59ee8d37230bce742f96ee4ba6ab1e45b22f37c43d9a406e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05a8e3740f962f774437266b2d60db51ad7fcb19e5142c877dfb8fc320eead52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e9245ea3df1fbfe6c7497b10882e3afa0fe5f3366e5c7995f116d43c5920468"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbce1aae10386a1ec8f581f5bfcf324591d9cbf5c48e1a202ac9d3b5eb147f1d"
    sha256 cellar: :any_skip_relocation, ventura:       "5baa00162e4d752a8224f2f469dff85af13ee27fe0d880f37bcc46bff5bd02ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2a33a2e41cbab68610e371ad42b07cafc6d68a9c41edf6680d14b5a19f0de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f54d7d6d79eadc5dea0ee120c7774b5d144c5f06dbc810b8b730d41bba7733"
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