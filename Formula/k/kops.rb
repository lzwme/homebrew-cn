class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https:kops.sigs.k8s.io"
  url "https:github.comkuberneteskopsarchiverefstagsv1.28.1.tar.gz"
  sha256 "ca9e4c504a6541cffb03bf405ae6a2a5b28f77c9650ab6a13358ef4565953d97"
  license "Apache-2.0"
  head "https:github.comkuberneteskops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b4ab8b1fa78189479919e7e4ed0d9bc5af45bb6ac8f8a1306fb80638127bc53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5ee65c4a278c5883d3716711d0c3a6611315d348308d8cfea3a0f5384a8d01b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdb0ecf84612022e0d66db676642112a1c2ea3b399de75a90e74005769f81d54"
    sha256 cellar: :any_skip_relocation, sonoma:         "70cbd9686e2b13143456aba164076c5239d1be6009bcf70fe638e45f7a84ea12"
    sha256 cellar: :any_skip_relocation, ventura:        "b9993acd323c0b71de37f14cf08aead3629d72cc635bbe8e213a737d0124dbb7"
    sha256 cellar: :any_skip_relocation, monterey:       "137c0f3f8c3bb5e9f88fd6dd03dc06e448988c2a1e76290118ccd629516f7be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d327c2a7de024cc6d53f792394e4d522a0730867b09a4b4eb68e8f5eb187c24"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.iokops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "k8s.iokopscmdkops"

    generate_completions_from_executable(bin"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}kops validate cluster 2>&1", 1)
  end
end