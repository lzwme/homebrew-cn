class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https:werf.io"
  url "https:github.comwerfwerfarchiverefstagsv1.2.274.tar.gz"
  sha256 "6bdba2b9e0a15d25e823199e0a4d771b18fdcf5dbd7ad48525db0e2cf8af3b69"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "735ee090872bc260e1e37327e9bae0dfaef84bdc61eb7a83d27e959f758c43b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "355a0d71094b03b36066cea77515ee4b114ad269d581f57c8fb84e8a9eb9f744"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb0dfb6cd5ab5cf430af9bb0df52f24d805d72af357cd89df673cd52435edc88"
    sha256 cellar: :any_skip_relocation, sonoma:         "71bc9e2b6319362317a57dab558c9591a86a0cdf75cffb8d62c7295fda626e9e"
    sha256 cellar: :any_skip_relocation, ventura:        "a5c66f07a1446e675d0ea2af6486b0694397ace164f6fc33963536f46070019e"
    sha256 cellar: :any_skip_relocation, monterey:       "df01859aec46bc944762022110b869b3b6c7422b604e43db110eaca1e3f67cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4036d26c3f9adeabf50f97b1ceee7f0f1f7bcc88915d053ea610df58bf2d8a03"
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