class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.4.20.tar.gz"
  sha256 "0068bf8eae3046ff1351f8ce08d4129ea41d56b628bd3114b2448ea9a74a424b"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4cb916ac2c4a629c0d30f6957dfdb50e489af549796154669a907b9de4373f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d7a4d388152a92cde2d4b0a3294430b9a32757896c357c160b4e68cfed01801"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "901e5314ed59f03696a0db69717fcab9fabd60340ef927636c88fc5cf0e6afe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "58fa0d9af2a36377dea6271a130b41743f924cf91c30fecd2e15260bbf4b4ddc"
    sha256 cellar: :any_skip_relocation, ventura:       "ed58b8cf99487c5e1ad5f4878046eeb1bdd9497c240602ccb60cbd0069aeb532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c90c7f97086baabaf6c195513c36a7bdd95ef5875e036dfafb87736ca72da174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e5727ff93ff22a4c65531f520efbcf911417f5c18e0fe1993d1cde422da3d58"
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