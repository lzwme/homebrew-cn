class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.9.1.tar.gz"
  sha256 "3f5d44f3213db19b24ca8d6c8912cb83572e58fdcfb1751e2bfbe473b8334063"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cb8ddafe0f7515bcb038343d834e2bef353b7c2cdb75245be1ed25a46d3ee53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1fb9ed8c408488b3e50f251ba1f5372c0f513913ec2b47f2070485f32a132e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b2a714da987b09ff997106999e8abb9dbd9e13280d40e2def5db67fa6c1a23f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e324c9ef8d2be65619c0beb13a6d6f1466ac9f542520d4ccb3bfb8dfedd0aba"
    sha256 cellar: :any_skip_relocation, ventura:        "8fed34e6df941ae576f5bee717106fc3c8d33e20cc1a072b70e3cd46ed3e1932"
    sha256 cellar: :any_skip_relocation, monterey:       "94272cf9c55d8b80b67c300509f07c49e8d2e2c4b86defed3bbf1984c64d033d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81c2c1bad4ccb34f7b51ae5715244c4195676d6376f24db2b300fe28395e190b"
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