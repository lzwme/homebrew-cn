class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.4.1.tar.gz"
  sha256 "3b1c0b0533395e803e6052252e4a91989e01c610e6f76b1b26cb2edfd359cce8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6104a98990970f11722f9483fdd6bb9b36dc5267080e6d605da0f939da49f902"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59aab07d2ccd18a84a9cab72f0745aba95908fe4ecae48bf27ee96845edce22d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10d589011e6cc459fe7db0660e02a7d19ad4f12b50a4585bff26909aee59fafa"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ac51ff587c414b26f502bd237a28579a59578d33886f560629746b9d2dde74b"
    sha256 cellar: :any_skip_relocation, ventura:        "b1a9c3c9560b6698504d1fef38e964d5091f6266d2e003b7b6d18b3d8e355635"
    sha256 cellar: :any_skip_relocation, monterey:       "390a0ccd06c94b1b5dc985582fbe80b2cdb70021b02821d95e563fe1f82ecdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fe104ba3b22c21855a6f9955b338488bfb5aa5b3a4c788d8f994b796f92d800"
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