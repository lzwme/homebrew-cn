class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://ghfast.top/https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.24.tar.gz"
  sha256 "635d2807077fe3a27f09b2eda18f36e30a20543159c21d58a7c0f333d139a21d"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fccfb4b9f3eceec4d42355af2c55df6b74d6e18b2905ae0762f8a93dd4ccdde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d36b34f46574c7cd1626329bd81da59bba901d7af80fc0d207b1d7b9bdf906bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9389193bbb3782fc655b81eed13e6a95d702a6ef1630bc2e6be336fd562eec90"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1fd0f74b1b4a975331a020d3cb91edb7add16883d08e50ef29bde0a26eb1c9c"
    sha256 cellar: :any_skip_relocation, ventura:       "c02eea1c8903a4800eee2d832704635e4ca9afa211a145f44499f98d14ae82f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "103948b994d8b2e63dc30e8d4f5b6a709c4438c3a8b03f3dacfe178627fa1515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eff94608993f947410204136ab11aa87f2d6402d9357e19e2a64cbb7713fe2c6"
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