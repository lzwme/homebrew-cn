class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.11.0.tar.gz"
  sha256 "cb46640fa24028142aaa2445eb8ddda50fe07d7a33250a0c9a884ff95d455f50"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c781289083759943224a2b70d9fc6e91b34c6997f7373aa968fd65b319534b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e02246af139bb0e89cfee6afb518b2b6a79af8c9d4d375ff3df933887fe4f10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58f8e5506667391e0a39b7fb8296dbff9970dbf434f60218e7f661c1679c0dab"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eedd8f87e4eea496cb59b9449a68c58dd2e25afaf4f259eb76ea094fe483400"
    sha256 cellar: :any_skip_relocation, ventura:       "0e86c3a749a968424b78c120a1de564437f0104d42290660d6a449207bc9fcac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f02dfcdff6600f5ff52b7b4ac29dc8a5e89a5482785e80f87a4a8656918ac5d"
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