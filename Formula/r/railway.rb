class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.com"
  url "https:github.comrailwayappcliarchiverefstagsv4.4.1.tar.gz"
  sha256 "f52a96050fb6e72214365f020cacb6d16b3459461f29853670974be3646cf18f"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21c1b0c452043a6a84f42c5a076ef319f427ac15f9c8b9020c25d179ae19820f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b090fde637ac5ccf11b5e55a95fc3581160c68dc45ad8303dde563df0016c702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "080a40d4c0f96341a07bd9a1c559d0ece5ea3ca6a17289a54e1638ce794a7442"
    sha256 cellar: :any_skip_relocation, sonoma:        "02ec63356b8271c4d180be1ae7ff2d3408ef1ba86139ee4486593e88d926a3bc"
    sha256 cellar: :any_skip_relocation, ventura:       "ee377f42549c8a8aab3dae1b59fdd664b21ca9274e9403d54e08b91df4dedbe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f38073631b34044f85adba2c8023f37f9f8abb4d8d5edc887ccfecdde1c6e31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee3803604074ebdb572837f25a012bc13d50c8b6bcbb6a2c15c8b9b880fb603b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}railway --version").strip
  end
end