class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.36.2.tar.gz"
  sha256 "f500e95511889efcd5316465bfd58f2427d2f04063c6f845cdac8adcaa56ba28"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5abd745de523c9581fc826fce2a375debcf0cb3f837acc1085a10decc4126d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8bbd5469180bb060507b16c1293bbbd8e8be80d96d9ab8b924fa5b81d8ed494"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2138dd293a5d7e3fc94fdbec460de43c640dca81ef3b46474021a0346b3e5a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "e890eb3e776c933c050ffd359af07ef4352353bdd79b681bfb55e2176a35e91f"
    sha256 cellar: :any_skip_relocation, ventura:       "60895612cf36ac9dcfd7c777c7f46913d4be38e22e941097c39ad58cb0d41d00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "103afa8892e213aa8d86133cd01699a77c69199056538be56db7e0c42282388e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "471f6e58ef8fcf447c4b3cf39a7acb286b629e25c1984840abaa553f7d4f0b09"
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