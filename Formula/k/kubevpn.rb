class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https:www.kubevpn.dev"
  url "https:github.comkubenetworkskubevpnarchiverefstagsv2.7.9.tar.gz"
  sha256 "b2cfc4af715d1a91150ca853d0adcb14fdd741735cff5e029c41f8ed8f1289fe"
  license "MIT"
  head "https:github.comkubenetworkskubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e641811acf482e4cd0f76c57cec1e8968a32c6414c8d74d41e9b7698eb734882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58a7690a0ddde3bdd08e2133ecd7acb8520f4ea167eee99ca5fc463422c9d102"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba1bea8a0ed65cf00aae5eda54297300a7e836ee393c70bcc2a59208c7a0a8ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cd95e3df06f47b12b6a9b130f867674ddc67354752f18ea01737e2a4cd7e551"
    sha256 cellar: :any_skip_relocation, ventura:       "899c9d8983d8ef455b2972a5526c71778cdec087779f5be2f24855c3ae7b141f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "299eacc13382aaa4024cc12133e3712fa774603c58d9109f36830660077406f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f59c854c5541bd6a891055e6c7fb2e99f159f59b423266a04fc32871a8ea5a"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp
    project = "github.comwencaiwuluekubevpnv2"
    ldflags = %W[
      -s -w
      -X #{project}pkgconfig.Image=ghcr.iokubenetworkskubevpn:v#{version}
      -X #{project}pkgconfig.Version=v#{version}
      -X #{project}pkgconfig.GitCommit=brew
      -X #{project}cmdkubevpncmds.BuildTime=#{time.iso8601}
      -X #{project}cmdkubevpncmds.Branch=master
      -X #{project}cmdkubevpncmds.OsArch=#{goos}#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdkubevpn"

    generate_completions_from_executable(bin"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}kubevpn version")
    assert_path_exists testpath".kubevpnconfig.yaml"
    assert_path_exists testpath".kubevpndaemon"
  end
end