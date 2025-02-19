class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https:github.compamburushl"
  url "https:github.compamburushlarchiverefstagsv0.30.3.tar.gz"
  sha256 "184011987aa1b3a76a322364bcf44219633ef8f388db57eb4693f64139f0db3b"
  license "MIT"
  head "https:github.compamburushl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88ec7527a5a24dba4be691e4bf070d20fb2357142236b0dc8e4c55401962795e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7e09debd5f49ae7697195c014bba6a6ad83f22fa9edd0d3a67d414e8cd2fc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffc21768b2567f55716ada4e2c881469c1b55f12289d162ceeb6811b41f5ab6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "277ea2dcfef835944504d65687804d09949bf6b090eeee6f17bd22cd88acd98f"
    sha256 cellar: :any_skip_relocation, ventura:       "16584dfbbb07ac85b35f93187dba3c24304c0e8a3d79691939cdbebca61ee509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80cb3f081fb3bca61dac1cfc770a8e341caa849deb8180f1e9df8bbab708f01c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hl --version")

    (testpath"sample.log").write <<~EOS
      time="2025-02-17 12:00:00" level=INFO msg="Starting process"
      time="2025-02-17 12:01:00" level=ERROR msg="An error occurred"
      time="2025-02-17 12:02:00" level=INFO msg="Process completed"
    EOS

    output = shell_output("#{bin}hl --level ERROR sample.log")
    assert_equal "Feb 17 12:01:00.000 │ERR│ An error occurred", output.chomp
  end
end