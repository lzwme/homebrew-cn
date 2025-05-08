class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.35.10.tar.gz"
  sha256 "c062f38515f2610735bac0b6a19fdd98d93eae858042d7bf8f8511a0fcd78298"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e5369be16a415a90e366d62647a4875cc516ca74ea93ddb4131376a230efb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f13ceaffd6153a50fe4c69b47f2fa086b309d4a533f86e483a781bf6b7786e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9587f38cb1073aa9bf29cf1faf32845348133a2d23a5bc9afb0ae6a673f5cc35"
    sha256 cellar: :any_skip_relocation, sonoma:        "f909e043787643473be746cfdf873f313261e3243f7ec7714e0fc684966a869f"
    sha256 cellar: :any_skip_relocation, ventura:       "6e98baf03e039ae493002d390848c14de81824baeb87d42287002b5156f90358"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dd36c4b3584fabbf31d3a173f05cbe018a531b0391a9de3c30cc0d04b39c3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "857d29db677dff2a35146c58ce4afe314aa47e384a119238ac0953de193ed771"
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