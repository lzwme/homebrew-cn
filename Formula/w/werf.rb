class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.281.tar.gz"
  sha256 "1ce40354c553cac046d94838fe8b342cba7812ee710ec8ab7f92f210f103fc0d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f165d3806dfa952560615806bf80761f5973141fb67679e204c20d5bda8b2467"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17c5198b6232cc9dac714abb0a885b569c468ac40e5fc6d97a848c55d2f0ab20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b71dcdb4abe6d6b44cf0e0d91c0e26c321fd4d1fb8505cb88f7027425740c7ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "7518851f27ba8b2a8a900d1899be2945a1c7a7a5bee5e0eeae54076922e1e31f"
    sha256 cellar: :any_skip_relocation, ventura:        "4c8723d86cd1e4a174ba96e63613530d220582e83f790ec2fbb8860d3c97bcca"
    sha256 cellar: :any_skip_relocation, monterey:       "51f7318535f4a3f34e49f7226f44ecee23228c8cefd16aeb6cf72007e73d44c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23bda80f6ef8dcf36a554b4dfcadeba27150240978c54923e9c9b6b998749a5d"
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