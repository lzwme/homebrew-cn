class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.1.0.tar.gz"
  sha256 "3f1c31300236fba28766cb499a7b889ed5eb1bdc52260eea79b91918e1be67db"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77943416d33a8aaefc6d54814daea0c6c9a5929169a5ba925fa8645e89ab0ed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af0aaceef3273342f27cc2ed4dc552c81059b9176cca64b695268d4d5b2120d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f39f9372f36a743658b4d9c53f49b93b52cd64ae7e3c84c3968003795549aef8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f36b4c6ef27f75e7120fdfd697c17b9ad123f26ad2bd7fb447412b1092d465d2"
    sha256 cellar: :any_skip_relocation, ventura:        "c2dedc34c98d77b3925dbfa1fdaf25d532a01c0b0c6482ea69e09bb606c4215b"
    sha256 cellar: :any_skip_relocation, monterey:       "150b9ffec80ac64cb787ffca41cb1c138cb75ed785834a93f7f3e788f01a9ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "605f49634c2f72afc708d545d3d3d790d732fccef0f51f72fe24031fe4cdf97a"
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