class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.10.4.tar.gz"
  sha256 "5d43462a7022225f819fee2caeca1c1dc851c943da65117e2ec3c122ef7023e8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b7cc3f647d66c9166702e23b104019746dfdec27dec92b069ca6b4f982b2b30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "065eaf10af7f54053556bcfd7a345f4a409bec4d75f701ac0130579ffa77dcd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca4391169f915103edfc17aa6cd1977654d8e2e4ef0686e14f7730255e93bdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "70e5e621989eb9fbd679dadf730c70eb2a210a1f04436eb5263e3de849213ec7"
    sha256 cellar: :any_skip_relocation, ventura:        "d560dc71b4abea01a0d8f43284ecee926a6ac00fe727fb3a03168a23cdabc397"
    sha256 cellar: :any_skip_relocation, monterey:       "bdfd78d2a91026b89c94f83af3d4b951eef9cfcb995406e1c433f2f8da05d16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5b94e71436feb19c5cbdde28f6016c6e72fa059b7e43d5cbbfd8d818061b857"
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