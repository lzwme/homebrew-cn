class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.15.1.tar.gz"
  sha256 "f3f610be6377a9b8554940ddaf922dbd01235936900724c2930b937f84e1c417"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d073fadd55af4d911fa8dac8a15ed77aabb307f87bf58e35a9ac2b63076661f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de47f9d1d285e492c857ca17bda8b6164e50d1d0069af6e61752b67ca7fd34ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e8f086bffca618efc657b71d281cb450b52a83a723a3e9795fe7024fb6486da"
    sha256 cellar: :any_skip_relocation, sonoma:        "c071654ae3895ce808601ab9d9613b5b0f0fc3200fdb5c7623a78082800ce18e"
    sha256 cellar: :any_skip_relocation, ventura:       "33fd67e9b5cd33adafb9096d8d3e10182c51990b301b438297d51289d53caa45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "505523d63ad92debf5b12e636257156f6dc1802fe7a151bafe67f3c2f1d98429"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end