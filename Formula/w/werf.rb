class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.287.tar.gz"
  sha256 "ccf567f703f9c0618084c96a642cce00c474f90a83614e989509e0966a06a426"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e6c29b9c0156905e0e7a75796699398fc6b42c3d67a23bfa88dc543a77ba89e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "908c0067231f3ab9245e2c3ab19a50dec9c1f836d7feb0fcacce7a3901025bf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97b5496c909913a2501409822f6c4dda21828a90884eafe134638dc622cbd36b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1a8634324cf827d2874f523910926c0239e2fea75b99db36f62a41bfb526402"
    sha256 cellar: :any_skip_relocation, ventura:        "daee5f83746666e91101db1f3eceedd08c3705371f96049b9a8e9d5259a7a29a"
    sha256 cellar: :any_skip_relocation, monterey:       "9d930b50c2e0773ec21beff47c21c9fb6ebe76f739fe25b08c1e321927eda826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3704ad25a20a144dfe8122043e10c203fb1b01cebedd20ad32f6fab11ba38e4e"
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
        -X github.comwerfwerfpkgwerf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.comwerfwerfpkgwerf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, ".cmdwerf"

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