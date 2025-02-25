class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.50.tar.gz"
  sha256 "9eb87d6f9fec037de2c757a54a48e45ec0c8886685892c60da9ab6282c281b55"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5ab0d0bebfe929d605a91b4616691e740efe4bcd158c27e174ebd12e977680e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ad40035e672fbb2a2806cb99d4b38bd2f73a06690fa6f457f884cabd4074321"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6d0da0bdec9fd20b0a7abc5a216fc38614f37a4b9b023a6c6b1cdf437d2eb04"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac171c4ffcd58311a26369f90c8cccc367b8dcc658ce057b2e7261bd49d288a5"
    sha256 cellar: :any_skip_relocation, ventura:       "aafb191b61002b58dbf84307bc26f3b5cc270bc7202fbd091c0505ac01ebd410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc88f09c297635c99b490009af9229e8acaeb04ee5f219a5f824bfe947e54e25"
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