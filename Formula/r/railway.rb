class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.18.0.tar.gz"
  sha256 "e54f2e76c251db584068f3d21bed5cde6706f2a32ec246486a7ad035b124affd"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "762936bbde569bf300325f4446e9bc17351e9d928ddff44cd79665b8181f2981"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0489e9f6f3ffba419c3d0cbc4221fdfa8ead533c5883e0ea92908f011c43099b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29db06c3d73f4e48b2c706638fbdfe8adf115e1906bedfdd6bcc82151103134c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c01cc9183346dc9c14ddcaff0ffd40c515791a79490383ffbefdf1f674f01f08"
    sha256 cellar: :any_skip_relocation, ventura:       "1915ff76fa28db4f7d82d9e8c413f9928c0598ec5b1c02dd7e23cd537f8bd706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24c7c2b74d33fc75e24c189d8683ed7341c1f1973b434b135c6ce3f0f54be51e"
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