class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.36.0.tar.gz"
  sha256 "c8b74b71f25921b468d2813b41e7c694886940b3633da92d1f513f626a7e3a4c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c1fef22b6e8302b20cd266db9b57d0a8587d886ac0deae92290e36655f5fe6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e64cc4f0869ba2dd580de248aa1f61f9ae6bf46ca4384e276b75b9dce859667"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "416a95fc4c9f559bed5f36605e916e3b900ffebad050c0819f9a6186d3691061"
    sha256 cellar: :any_skip_relocation, sonoma:        "f02dab9dab7e7d1741333415b7378959c04ea1ce45caf1e4fa25f990548604b4"
    sha256 cellar: :any_skip_relocation, ventura:       "2c567c3584480e040a87fa9f5c22f658232a8a18f1ddc7782863569e968d7b93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4552f5b063c45f4c5bc94863c820f6b2422576a5e02d423a877baecee123335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b430b85c0d0b2d661f8b9b0e901aa2b39673a264c0e3542de3d0fa5323402015"
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