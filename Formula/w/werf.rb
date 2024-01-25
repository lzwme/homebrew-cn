class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.282.tar.gz"
  sha256 "8785b9fabd5e3651d538432449bd6586a2b38e70d3ddab23b557f94e9bc606c9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efb3acde73fcce0c856dc8e09db0b0cf675fe1ccb3889aceb478f916c0cb3920"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b14f7a4b482ff2ff58bd7ee70a6f6ab5c7beea7b2e62c19b4903c3ba1eace46b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e464e4ab30819e9019af85064a1942361d3aaa72a34941e3ce51f12e4ee9634"
    sha256 cellar: :any_skip_relocation, sonoma:         "d541851b5f6da1510d596f27926fa14b6b5cf3449bb3d582b76d2cc3fdf7efd2"
    sha256 cellar: :any_skip_relocation, ventura:        "7af87a4533a2f08e0b3c159c5257837c1525270b4acf38503872d17a5f5ff921"
    sha256 cellar: :any_skip_relocation, monterey:       "4060de3adb142c8390a087741a7074cd0959381d9d1908abfc5b83962f563077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "176e68cebd3b8014b868fe6b4e571932984ca4d0cca269f500518de597e2d573"
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