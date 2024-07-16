class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https:www.openshift.comproductsamazon-openshift"
  url "https:github.comopenshiftrosaarchiverefstagsv1.2.42.tar.gz"
  sha256 "2ae790cf48177f97d9d5a8ddc5dc6876f0850881ddddebf3573039428326d05a"
  license "Apache-2.0"
  head "https:github.comopenshiftrosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9fe3b385f01513090f795ada0fa751bcb80c3c88535fbe0e6c4ee527246277c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed84441aa41124f6a6600381926965292c4ef3fff06578b0771b35828929eb0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c5e8543ab3b5cd56db61e8c3f2816b49de27850312eec47accc391fac95e05a"
    sha256 cellar: :any_skip_relocation, sonoma:         "23fee9facdae8fe772a74fbc9f037c57c020cd2f21a8cb90fba61232ee869fc0"
    sha256 cellar: :any_skip_relocation, ventura:        "f781322ce8aa350353141f25867d02b23a8940d1744cb9150ba825dbcc0e04b7"
    sha256 cellar: :any_skip_relocation, monterey:       "4190d2ef7d179b6eda307e01dcd5e9dd82d7499b8444fc4611e6969d88e95d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d7320221d66cd065587dddd7af032365fd1af219739b3b1a6106cb7ea2ee2a9"
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