class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https:github.comhetznercloudcli"
  url "https:github.comhetznercloudcliarchiverefstagsv1.42.0.tar.gz"
  sha256 "b99ec2b89d1485c3b14d6db2966cc355c9173ca98fe29754216b70f72317d8ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90a3b8575c432e7cc56cb04fcbb8a7a4ab6253df801858abe99f86cd82e6357d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b314fa34e6d3dcb6361551b3d6744c8ea0238949dced05e7ec53841a8cd9431"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c19b2daf5269cca9295b272209ee4860cbb2b4ac81a59dc2e40695aa06d8f117"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1d718f48e52398a1083974f9f4ddc3a947ab5652fa323139e807f30e4998094"
    sha256 cellar: :any_skip_relocation, ventura:        "e92f84d4dc127beacf453beee74da4f94eb944de9e8804b14a8a6d598f0b4740"
    sha256 cellar: :any_skip_relocation, monterey:       "72d9af169a42e2d1f247d1da6f2f3c78dc454f4d8a4f4c399d2a551024d8c525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e87efffabca074c7d894e66bd70ad5ae05af24f8d52e135bc62569f4289d06"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comhetznercloudcliinternalversion.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdhcloud"

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