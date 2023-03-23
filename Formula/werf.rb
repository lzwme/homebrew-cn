class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghproxy.com/https://github.com/werf/werf/archive/refs/tags/v1.2.216.tar.gz"
  sha256 "707815885610ab4033f303ce1ad46cbdef405eb01edaac15de59e56ec41b5401"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10ca62e87ff67eb9f2db09dafe993c7863fb7c9fbdf9ecc3f8cd95ec5cab330c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96e26a9a86092f36c9e5b3e1ce974ed0f3f163142f1677637009421cd8c13b1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48a3be67805b9886d3948606714119ce83497af5123d88984310381ccac03d90"
    sha256 cellar: :any_skip_relocation, ventura:        "bce3af88518d92661f07b5d22cb592ddd76fd9267c00cf69646cfdfdf9b00012"
    sha256 cellar: :any_skip_relocation, monterey:       "5a5a80ad5c90aadf40e731226199d7c79869f86156aabde2b2cb1fd31f6fa17b"
    sha256 cellar: :any_skip_relocation, big_sur:        "02c2cf024a7b9d38707286549988647cf092d4b2a4b2875e50278049d1c70f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b5f4bdb15f45398b678df7fe7755ce03e246d3d34614826ea5c4b8827bf09bf"
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
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
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

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end