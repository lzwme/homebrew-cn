class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://ghfast.top/https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.12.tar.gz"
  sha256 "bf8c659236680a563af798048d43bad7cf60e910efec3bee3d230c6c147a09aa"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58db29d7e5b261f1372912d03ae8950eb3016933292ac513e2affbc38db4d8e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58db29d7e5b261f1372912d03ae8950eb3016933292ac513e2affbc38db4d8e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58db29d7e5b261f1372912d03ae8950eb3016933292ac513e2affbc38db4d8e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "50259248be9f362ac6890552b3b8e1128efaaf43d1d76de65912f7f4aa806b26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c5317d0a151ea24f45a2268279a0e7ce0452f8eff84e1fd08688392492a7199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f972a9877d83030eec040552ab05729b7cf6e0059ed23852a17ad084e144683"
  end

  depends_on "go" => :build

  conflicts_with "open-simh", because: "both install `nova` binaries"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin/"nova", ldflags:)

    generate_completions_from_executable(bin/"nova", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end