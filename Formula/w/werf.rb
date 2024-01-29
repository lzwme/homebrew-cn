class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.284.tar.gz"
  sha256 "0e6be2438a287958b843b855bf57bf3d121034f433288730dbe010e9e8dd263a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f5caf009079afe71d43b2ef647e08dc79f7a1a2faea995678d5a36d5e46e730"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9455d61219ddc7cdad0ac9eae2daf3a7c4bb87b41f7c938580f8ba38d08ed4b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdda9612eff8f774bcd366bfb13e0a7e347741ab165bf1d50e459e861b407efb"
    sha256 cellar: :any_skip_relocation, sonoma:         "41e3e0208d7d84dcd979f2f57312dd7c44df98789d4a21462ca5357bbfc410f5"
    sha256 cellar: :any_skip_relocation, ventura:        "dd8979d0163c885ba676c508a43cc9c5f4e3ac46fdf690a06625c28caf6c64d3"
    sha256 cellar: :any_skip_relocation, monterey:       "088be94fc0f13a159e840122ea026847baf192379b9ad19efe8f020ab05a5008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d238d0d3c045035ef52223d4448056da4ab875a3e2d923dc4b8a7a0e9b054c0"
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