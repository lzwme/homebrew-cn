class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.35.7.tar.gz"
  sha256 "15426be973b184ee86473b687baf45761dc4038da3b8f2cfecef1a65c6bb491f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0676b228cd950292a3ee443902364e8f1f24b42985e5732ed1731a91c04605ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92a0ae53e0324b6fb316c700bf83c245fc40c33232a784ab8a8bc6ac11ed2b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "566eaef1e1def428e3c485e382acbe71259666431b08646475d4a9dc659d6e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f26d511dc3395e8423e485ce1ac4a267d1c962f94172f4b37676d69381dd7ac"
    sha256 cellar: :any_skip_relocation, ventura:       "a6c1ef502f1f3a96b6198096455877f78733febcd28ae7a9623551159f508aa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5312dffa293c264667886ba4473cccf58c1ae35b0f17702b0155283e9afcddca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2542980e50550af01e4e48360d4ebeb951fc0aa736c8cfdc8ad13216e9883f0b"
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