class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://ghfast.top/https://github.com/werf/werf/archive/refs/tags/v2.48.3.tar.gz"
  sha256 "c92980c17443afbe893a49c83c6d43e9fd03eaecbeae9b8610d8fbac4aba7958"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6fb2cc3e9c3e4bbc5480b77d99161280833281f5e222b3bd18d82d9cd681473"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f32c9203307ac16f68826bd12c0c73671ea1953a768135a3cd80352699c910a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f847b07775afebf06dba98312177f104fc566796e178ccad32099cb8744fb1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ce3a6895c9e397b5617308d9ff99609c7d74949a1512d4369cbd4f9caf18c97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24a6d0b9e3c5d7b7798f5377b720dd182deb377b9fef4d954742b9670486316b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c8edb345d9f1fa4f5559b859ed33b3c2ef640a44cbe31a73aac025921ec40d"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ]
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
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
      - image: result
      - image: vote
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output,
                 shell_output("#{bin}/werf config graph").lines.sort.join

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end