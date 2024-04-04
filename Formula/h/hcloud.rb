class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https:github.comhetznercloudcli"
  url "https:github.comhetznercloudcliarchiverefstagsv1.43.0.tar.gz"
  sha256 "51a979605cce7a146135f58c9b0825ecb39aa6f35cd9c5693c5f048f6e9a3c47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e13671f2840071d1858f7b46d4cd586d28fe06bb661c2cf9014d9164ed44315"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe3bda67d5850fefc78092fa5acc548812e923cfa08cd899c97c6ef8f0dc6b87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e35e13172e11a9430afbdaab18219bd252e23efbe24ebec9b1e70a63fee4f6c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "145e081a797d2b69bba61aca043d9977dd94da2bf4ab9405b80c18f56811f423"
    sha256 cellar: :any_skip_relocation, ventura:        "6c782e3cfea79d73091aa4525fec988d1ace0a164805f24282dde6462eaf1405"
    sha256 cellar: :any_skip_relocation, monterey:       "0a3a88bab4aea3ff25357ca96cacd3b6891bac4b222a06a0888942bb8be50829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8717a76af336e244d0733b68f01b66e1594cb86afa1b2d82c61ca96f1f0c2e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhetznercloudcliinternalversion.version=v#{version}
      -X github.comhetznercloudcliinternalversion.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdhcloud"

    generate_completions_from_executable(bin"hcloud", "completion")
  end

  test do
    config_path = testpath".confighcloudcli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}hcloud context list")
    assert_match "test", shell_output("#{bin}hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}hcloud version")
  end
end