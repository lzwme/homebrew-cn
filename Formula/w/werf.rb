class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.10.7.tar.gz"
  sha256 "f06a2ea3721790a8f9b9df2ba72796a413ac2a04cfb2bfbe09b28e268aca2f76"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f87b1aa4a258084ccc8e79dcb3ce3b7bd0de8f340b5e5f51ed972685954ea88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a56e09b41843b4785724df427d8455deead858e26112063f7a53c6edbdef7395"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6451db014e6d9875446b77393e25409ab48b38e81d8466303fbf6aa1e01fb25"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe07b6a88d863e2e56c10f620e65a32fbac7a2fa0aaac6c5928c45e9acdbaf0c"
    sha256 cellar: :any_skip_relocation, ventura:       "0867264e32a3bf56b8eb05f5bc578d7d071cf4d2ebb4b75af8254c2ab1e46e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee78d5788f19eaf1775c66c5f206beab215f01efde02ec7f8f036d6095dd767"
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