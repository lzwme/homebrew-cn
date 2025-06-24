class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https:github.comFairwindsOpsnova"
  url "https:github.comFairwindsOpsnovaarchiverefstagsv3.11.4.tar.gz"
  sha256 "e4364254b385a84701ff649bb47114b5e7b5a59d3d1e61a12ea9663715164fd8"
  license "Apache-2.0"
  head "https:github.comFairwindsOpsnova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0937bfd91f4275eb6d901a99d5b8b50efd9d25c68fc1b1d173df95ea2ca01bb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0937bfd91f4275eb6d901a99d5b8b50efd9d25c68fc1b1d173df95ea2ca01bb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0937bfd91f4275eb6d901a99d5b8b50efd9d25c68fc1b1d173df95ea2ca01bb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed7ecf87b7d0bbf9d49c82edc516987f83842c45d29c0bb6003c75056ba1d292"
    sha256 cellar: :any_skip_relocation, ventura:       "ed7ecf87b7d0bbf9d49c82edc516987f83842c45d29c0bb6003c75056ba1d292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db7a9d2a51acfbf5816113bf7ffe52f3d663145009bfc0c27534d7fa324c159c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin"nova", ldflags:)

    generate_completions_from_executable(bin"nova", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nova version")

    system bin"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath"nova.yaml").read

    output = shell_output("#{bin}nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end