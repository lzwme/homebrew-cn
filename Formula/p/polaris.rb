class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://ghfast.top/https://github.com/FairwindsOps/polaris/archive/refs/tags/10.1.5.tar.gz"
  sha256 "2048ce9cc7d1bf54f21913d174c1d357e941ee3b3c4a683709af9d35bd70e470"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fef9278597614ea01255880b8f612f7d963c1648d109d97c4aee76b2a435ffb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bee53b266ae1976dbf17d11784ffb99c0bd226925679f0197516a7b73fbbf01e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d5fdf77d09b9117e8fa505a6495cb89f749cd4561342065133aad9227148d88"
    sha256 cellar: :any_skip_relocation, sonoma:        "d29a7d47a7de25939b032dae4309ddc63541cbdfa18230e7c7386d271596ab04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a573dbb19714348e67985ecae2697648b5734006956b37cdec5fed7568d91ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "953fa279b825ee5a2b122d9fce06ed20176bb31fc49020ddc7a03423a2f99384"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"polaris", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/polaris version")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: nginx
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              resources: {}
    YAML

    output = shell_output("#{bin}/polaris audit --format=json #{testpath}/deployment.yaml 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end