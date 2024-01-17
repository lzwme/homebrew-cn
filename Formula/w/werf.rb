class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.280.tar.gz"
  sha256 "af0fa9e9f304bdc9aaa2f2b30eb52fcfcb9022cd85848ee1012aee4aba4e7730"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4db8332e521a17b352cddb93f64aa304359321e46ba69455e32b0978818ce6a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4adf3059abbe9d4eed1796180d1cc74401773832f452634192695c36e641b1f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f78ee420e3ef497dbb1f93fd0999bd8168d982f36ce2f179b2be48f6eb8ae7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4855cd6293406a075aae47f947e52bfe9a1f91dac7179c6ff28f30e3f977b755"
    sha256 cellar: :any_skip_relocation, ventura:        "588a739141207427fc506d6b32eaf41059ec65fdad69d4e25e5176c6866cfa00"
    sha256 cellar: :any_skip_relocation, monterey:       "6a13266a2f1d2aeea882a3c04d303a2e8bb51998e14e49b421fef5131b6baa9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbd6a233e31a54d8b8f86ddf382db7e9f6ce9101a8bde859aad8089f4c9b3c91"
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