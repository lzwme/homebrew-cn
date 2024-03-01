class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.295.tar.gz"
  sha256 "88027c43b1a1e3984865d75838c7b38e79a584825f2eed23e33a2bc982ab187d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c99ea2f9d7f055c3692be3c394436fb3ef30b9fd195b3187413691a4a82e66ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efbf6214f149da3633ab503a42156bacec786b0567e48dd2d49c265854a65f9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8254c84db0c8cac491ddc80c2463fb705daaede8c90de53e8285c06af406fc17"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b02797aa324372319631eae59023219e7ed0866f004647b0b750e120d20159a"
    sha256 cellar: :any_skip_relocation, ventura:        "9020dcb4b760edd19ab240cb26e0c6b8e3c6cf392a85dc406fe67c228e39211b"
    sha256 cellar: :any_skip_relocation, monterey:       "09d9e8e705c68c8748bd88c2b2bb7f8b06943725bdd007242d111d58e8c0393f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369e8ddac8a6865c19e497c232896958657dca911ff595fe82fde9e92cceb976"
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