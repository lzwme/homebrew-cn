class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.4.4.tar.gz"
  sha256 "589a737260331f65f9e5b68b785b13282d1b29bdf51e9436154a8c812ea523c5"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bc90965fd92ca650af111c893f672e4b53258c48d65318128c7a62275017750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccc40619b251420f4928e9b1209714cfaa16c50a1317fd1db2a04c93cea424e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c42903063db84bebf68fe916319bf7864d6bb3164ec245501515005e0393e84"
    sha256 cellar: :any_skip_relocation, sonoma:        "a70383258b72855787b370c5c6ea2cc20c6e37ccec1144c445f59f9dbad068d2"
    sha256 cellar: :any_skip_relocation, ventura:       "ae4f88e4789426e7883f754107c5b3804c21b27f3afde7a127aea4b3bc630885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c03a0a3e9a311073b782b73acdebd6b38a3819f76e1dfe0dad37fe3ae0756e5b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"k8sgpt", "completion")
  end

  test do
    output = shell_output("#{bin}k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}k8sgpt version")
  end
end