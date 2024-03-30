class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.301.tar.gz"
  sha256 "7b8ac12224223ac39ce4c6c52437161a13a862d5164022894199302d82e8acf5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d6ce21ccbf013145910f4bdfbee34883444bf251ffbd2c3049eabab031844d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e61276ce4accf117120eb39772c4bfaa49057eecd44c19f6c4746761db9ab3ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caa10161d874adb74d68afc48f3256b494c22914a8e67497bf00edb3c66a1b78"
    sha256 cellar: :any_skip_relocation, sonoma:         "56c4ec12bed33c74b10b489a8c81ce44ad448737bd013e1f9e272494b3d8d996"
    sha256 cellar: :any_skip_relocation, ventura:        "706d9eacf5565a9177d96ef3419763ab9e6025f950573b2af748a4dac3d1251b"
    sha256 cellar: :any_skip_relocation, monterey:       "5d443aaa523526eb7796838df3b9e9550b274f01951291ffd6bdca16b06f5f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5df538d98d25471cce49b1a2939ed60bb47e785af24af01b3a5007e7e95b77a"
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