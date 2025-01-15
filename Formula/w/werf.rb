class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.18.0.tar.gz"
  sha256 "94ce7738b907ba25efe6103db1f0b0cf84abdacf9423b4f4889b124940a064fc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1208d43a1dd4d58ae2a3f409f6cac1d244ad0a025ab5f1f4517ebddd2c06a84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9b0e675bf9af23a5c00ebc6d99c9980b7e299c0c7b8be9714edbeea612636f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cb574444beb7b0cefcf684ec8f16df2d91c403ee3eaa629084824fb4ee3f7f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ebc760c974d1246f2836f32500a34d8db15d5f29c23bebdf143ff371b1fb944"
    sha256 cellar: :any_skip_relocation, ventura:       "62a2eb51b244a148b33103f870bf386ae0b17a419b9732e0fc58c06ee5fcadc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dde373cf650860bcc9995e5859875f0c91f4a3d784de26126465321878dc596"
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