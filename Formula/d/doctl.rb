class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.123.0.tar.gz"
  sha256 "061f85a79a39011d3f71c9c75762d2316e96cfb1c9e6dafde419d23a977f4b9b"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e8f83513dea0b1d3a83d7e17e53f2c1f1f62943c7adc54a1fb3922cac6677e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e8f83513dea0b1d3a83d7e17e53f2c1f1f62943c7adc54a1fb3922cac6677e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e8f83513dea0b1d3a83d7e17e53f2c1f1f62943c7adc54a1fb3922cac6677e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae293a10e8e4bdb7eeae77ede47d090032c044e602c1f2e88807f9f5d7945e22"
    sha256 cellar: :any_skip_relocation, ventura:       "ae293a10e8e4bdb7eeae77ede47d090032c044e602c1f2e88807f9f5d7945e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8fe77d09b78984c3f9a378e36c694f67cfabad7c5c8b49c569bf3f24db7c1d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdigitaloceandoctl.Major=#{version.major}
      -X github.comdigitaloceandoctl.Minor=#{version.minor}
      -X github.comdigitaloceandoctl.Patch=#{version.patch}
      -X github.comdigitaloceandoctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end