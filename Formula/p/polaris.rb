class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://ghfast.top/https://github.com/FairwindsOps/polaris/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "976a9c09667b0ee756ae8d1727ea9b582e24c64bd91093413be91466ba54782c"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d739a9cb71e2a332b17096291c50126b86fe9059d932c07d1c43a467e61d200d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dba6b563cda7dddd0a7c7cc20faabdd9261947672f98fad888ab76825808148"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f29c9407b730c197d91c7b5e526a25dab543843440833f73d8e39346cf30256"
    sha256 cellar: :any_skip_relocation, sonoma:        "be9e4240a633b283476df4faf2911e99391f885b826cb1498cb3a752feb9cde9"
    sha256 cellar: :any_skip_relocation, ventura:       "163b97b47cb2f5c5961f11635c32b50af754a70accc896b7f679a753ea6176a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7689f0bd2ab52f2ea336159b484bca7fbc21ce757f77e9b09364d1b547879e9"
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