class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https:www.openshift.comproductsamazon-openshift"
  url "https:github.comopenshiftrosaarchiverefstagsv1.2.37.tar.gz"
  sha256 "65f6b3984ffcf369b80ef4af76a3c7858ed5474924e3829a45523892683c9e7a"
  license "Apache-2.0"
  head "https:github.comopenshiftrosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfe27a372c5f5a857e156d9f9f2b8a32b239e6bcce37e4f84ef44c52a2f706d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04fa9effdf75d17cc33efc051a008de3b0b019bd17baa19e7b976c43a241d0e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "348ae119f736ea805d2ced11c6953cee66edcbd5635f47d576ee8595dd4141bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "783b30d164d6c3d8f9108bbe91bc9077647e6407ee0ac07693bcc52fca925bd3"
    sha256 cellar: :any_skip_relocation, ventura:        "2abdb36d018cc9f16975233af87dc9e3e5a072a8c8cdd23eba1789429fabc8b8"
    sha256 cellar: :any_skip_relocation, monterey:       "e668d75e6679f07cd5a4f4527504c06a67f3c87f2bc8f92e61bac70f2fff00b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4554315b066ca99ea687c7518c2597eb47781ba5c314177ff515843c572b54a9"
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