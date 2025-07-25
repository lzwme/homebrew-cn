class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://ghfast.top/https://github.com/FairwindsOps/polaris/archive/refs/tags/10.0.0.tar.gz"
  sha256 "b5ee1a9f31c11c44a11364d838f14c661c1af1c188c78ca431b66e5533df3aff"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e696df385c784b3d6ac01ff8bf8fb7d1ed7d567975187aa7ad9364ecfc83cb6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da02d33e584b1ee3946761f0f2b04315e71d1bd52d1888575c7bf2856f37dabe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c80ba5163b2ff56d3a0e9c730f103d067fd258bc08ced16896fbeb8379161f02"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f3f67999e7d82d5f6077737cdf850ee678e93b87cbf263c9fe715cc7838ccbc"
    sha256 cellar: :any_skip_relocation, ventura:       "2f9fde3a195c0bfd22202dc6747261465ee16ce437e9df4d3b965c5f2566b79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9b4baaa20c4cb42dfc4c7fa9422ed5e46181ec35cdb9c5bb0148b93bfeb529"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}")

    generate_completions_from_executable(bin/"polaris", "completion")
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