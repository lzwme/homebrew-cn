class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.12.1.tar.gz"
  sha256 "03041708522319a228736acca5f38f1d3054bbfb15df3a026ae21446e01d04b3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cf4ded2f915ea6be34738d4205a65e5e7766bdcf0371367bf6773015c5ceb49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fde7f0f4a9569ef47173cd0bdbed0bfc3af0763af6285739566f797c9f46e91e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5fd19ee9e4ae167e2dab8446b9ed53df4fa580cf3b32d3b0c72a8e6dc49d752"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d027373119a0eb49347439e4fe84ed6fa8b5d41e3812f04b8cdcef13c78dcaf"
    sha256 cellar: :any_skip_relocation, ventura:       "d0d3965c0a48f77ac9792418c009df58644fd4c12f4d2b38da838e0f54bb7843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2a3784748ab83b2eac302132770239062c2813786d728ceaace0d77061c8559"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
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
    werf_config.write <<~EOS
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
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}werf config graph")

    assert_match version.to_s, shell_output("#{bin}werf version")
  end
end