class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https:www.openshift.comproductsamazon-openshift"
  url "https:github.comopenshiftrosaarchiverefstagsv1.2.47.tar.gz"
  sha256 "5cb22453b3e012dd2c1833e8638a130c1f7a1916f37abe68ffecf54a891a8eca"
  license "Apache-2.0"
  head "https:github.comopenshiftrosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2535b038026d01c908303d6eb5ef0b505d8cfbe7164d0e5389a6b9b0adc345a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c07e44adbf78254314eb936741fc26d143f9ce80729672e5828d960e6ecbb35f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e77a46eb139c38100fb60135d12fb2646e945857ec9b7b97a986a0959bc1cc77"
    sha256 cellar: :any_skip_relocation, sonoma:        "647e821dedda2e977395c5f1c41ecf11748da462e6b6f9ab2ead47fbefbe92a1"
    sha256 cellar: :any_skip_relocation, ventura:       "13931f13367e3e5f9efa2446534cbc9728ffc31b1cf0a3b143fd53e3001b846c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b48657253bdaa70d6d378036e0e9a65b8b5f4a84380edd07db8daf5123981899"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"rosa"), ".cmdrosa"

    generate_completions_from_executable(bin"rosa", "completion", base_name: "rosa")
  end

  test do
    output = shell_output("#{bin}rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}rosa version")
  end
end