class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.16.2.tar.gz"
  sha256 "91953b85704fe5578f5bb783990405413949dfdc0c0da5819dbded1ea0997d5e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1f48e5b74ac997ecaa6a24e3c526e5b0a8ca431d381c7d763854404925e0343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0559109396cefe26010deb43fde1a87c9cf6f4b9f4e3197bf3dad046ec51895"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc6c6653d408cefb96c588a5aab597a82027204c3e23bb16fd8a9b0a7ca4cc38"
    sha256 cellar: :any_skip_relocation, sonoma:        "001cdc1ebeada3909209f77f7eda75f90ec08097425f99a7cb87a4a6e90d9f04"
    sha256 cellar: :any_skip_relocation, ventura:       "115a47288697c90b12cba97e31e586525363d3604f81a0c806c9b948cf3d6219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f63af598345069a6c37eb02758fcb4fbadcc63660e26497bcc49d914dac689"
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
      ].join(" ")
    else
      ldflags = "-s -w -X github.comwerfwerfv2pkgwerf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, ".cmdwerf"

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