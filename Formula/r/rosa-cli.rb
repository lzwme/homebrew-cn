class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https:www.openshift.comproductsamazon-openshift"
  url "https:github.comopenshiftrosaarchiverefstagsv1.2.41.tar.gz"
  sha256 "5fd3669d8c3892da6b56700d1eecbda9ba2663f5099858014c4eda10a0e4f007"
  license "Apache-2.0"
  head "https:github.comopenshiftrosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09c4fff9b6db46b9d976a7ffb4d7ac41350d53d1549e30467feae025e8e90e6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adb2f58828faf076c63d98259e3a9776cc18f30dcb43338382cd7b79fba12a56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "835903c0a60680c113d9804c908a02702a2064c6beb3ddaba5cfa83b62669d68"
    sha256 cellar: :any_skip_relocation, sonoma:         "abc0f5984c24777020afe4f9dcd52c7f99a48311738642fb4012e0812b03c9be"
    sha256 cellar: :any_skip_relocation, ventura:        "4bafe826382fe4cdcbce93c72c725d61657093a1f98edc14c861c3c61ea7f3c0"
    sha256 cellar: :any_skip_relocation, monterey:       "b81a52ed781e7790b5f36e526f1a674d659b8aa15644f4cda2fe2167958eeae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6a087270855b1ebdbf4f131152bb1cb7254cfc8b529853bc7719587a7565b5"
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