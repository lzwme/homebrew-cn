class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https:www.openshift.comproductsamazon-openshift"
  url "https:github.comopenshiftrosaarchiverefstagsv1.2.33.tar.gz"
  sha256 "54997f2d39b2317969f768bc740f122d091f89cb77a2d9a605a465fb18b2b9b8"
  license "Apache-2.0"
  head "https:github.comopenshiftrosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0482e73aa7c2b6d6b94348cdd472462eb3b52da6bc6232e35878708db2530158"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e859a16c48336163ee3bb973250ee933d40dc9c2f4729c87d42402c6f800aed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "921ab22ef150077331337c2ad6e8945a082203bb90eab6f5832325c242b668ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddf591be8d5e487cb60147b46f28e2648454d7abee84c39e1dcc09a066a2e5c6"
    sha256 cellar: :any_skip_relocation, ventura:        "183d54a0e06584948d12b2637a63ea600ad6a63bc4bedaca47b58aceb9013957"
    sha256 cellar: :any_skip_relocation, monterey:       "257881d9bbfed4692f3369e78831df4c1de29ddf8e3944655aae9b9fdfe1fc44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36371e2c8705c5d7e361ba3942cdacc109846f3a8da20885abd1678fd6d63abf"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin"rosa"), ".cmdrosa"
    generate_completions_from_executable(bin"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rosa version")
    assert_match "Failed to create AWS client: Failed to find credentials.",
                 shell_output("#{bin}rosa create cluster 2<&1", 1)
  end
end