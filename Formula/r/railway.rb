class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.com"
  url "https:github.comrailwayappcliarchiverefstagsv4.2.0.tar.gz"
  sha256 "8a3ee786afa539aa502bb62633283b01ff2b3a9e6f43afe104e59721c94ed618"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5096ea74a05e5eadcecc5189f358685d2b33553b02ce7c5d054ffb02500f021d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43794dab360e27cb7b5fa0a3da698662e4610658369f9e3d91c9cee0d9f38907"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b0dd6ea7f689ed238dd7ff5be79f80c959667840cc4a7d9f44cdb0e69aa505d"
    sha256 cellar: :any_skip_relocation, sonoma:        "21fca84fbb529349cc2f2ee5d21bfc3f2cec1366582b21d25106a63c99fd8bc9"
    sha256 cellar: :any_skip_relocation, ventura:       "a155c4f70188804d252f7d05c15c7f793e193bef9983343cbb7bdb29feb50c73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "967d4efb4ec716d1f3b595051b1f442b6fe0e8ba3ae718fa1d620b1a5284fe77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd58e5f815cdd8188d50d9202dbdffde3f144b816c42b43706f04fe8a519085a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").strip
  end
end