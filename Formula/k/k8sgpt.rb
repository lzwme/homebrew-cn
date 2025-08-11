class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://ghfast.top/https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.23.tar.gz"
  sha256 "96fcac67d82f798e9796cbab30608dabf13620dac1a8346d82f5e40e07f794da"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea0ace32740c4973a8d03ac297da271cb39459308c796973782db1239fa5564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "083ffe53e89671a1f09f6c7959f74c558c0dadfe418883706859aa67be917199"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78f061dd2e74c58779ea4ba3054bec3acb3006130a61def2b1e29596146b8c25"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8ccfd864065e039e0c5c3f5a9479ef5e3b903ce4dd9b4475f2a6b4b86c77bc7"
    sha256 cellar: :any_skip_relocation, ventura:       "dd275e4c41cc30004ee43b9f4e5099af6c55f6ad40ae48b3e05b8e71982fd4a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecf8a7f113c915510cab7d39d112de33762ddc3f16128c1f5eead19df7896910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "109700a80045c7d4dce0e70a36bc90496949bf4274e85824e97b17c67f08198f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k8sgpt", "completion")
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end