class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv2.27.0.tar.gz"
  sha256 "d5f8d8fa94265440fad6da6f3d2cb036a53b1fa5266398ad7dc6b6ec09ac2a15"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d677cc3a5e29cd6b199841685bda21bf10e35697d1fd41a5dfceaf034aefd53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "059ce8d74e1c2607b78ee1e54b928fecc2efc61316e4a420403c136043eef026"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "568e2ab098f26119ae75a3f9e53691d229e673e3820eedf353675914f6c5405e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eb5d92026bf26bf0d7c3bdfa41448f3915e5faf0db3f347e2dc9db7508e2648"
    sha256 cellar: :any_skip_relocation, ventura:       "d3be8e296acc0508df3e0c821adf96c8987a226597bbbcbe42113a43239b2c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1683cc29c4d74c46917d8b4e6c70ca459a859d5bb51e561c3f50b6c6ad61d32e"
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