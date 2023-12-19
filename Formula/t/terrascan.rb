class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https:github.comtenableterrascan"
  url "https:github.comtenableterrascanarchiverefstagsv1.18.9.tar.gz"
  sha256 "4ddcf499d68046152e6f4be793e41749d693fd082babb0ea4cb95f0bb58efd42"
  license "Apache-2.0"
  head "https:github.comtenableterrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dfb74df3086a53c399274e62084fb79e9d1d70c359537af2712c88eecafd6b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "804469dd30aa6f91856fba0d1b6d30bc6dff4af69dd413189f274384c8e19de5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6435381e8532395255a8e35898ccf5708745102f2a367b445db1316505b47c5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "793898331bed9e1a5be6f9dd95432aa1d29e8564bcb0cdbc6645b6c0a9fb1b1a"
    sha256 cellar: :any_skip_relocation, ventura:        "fc42b4af2e1a636d701d4a4321f986c359de6191af169527732a76f3510de43f"
    sha256 cellar: :any_skip_relocation, monterey:       "8e14e365e1dcf258d4003194634d17e5947a02e18bd77d8bf32788cf90bc99c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e97955960b278e72a4dc48d9a5eeb7dd850c7f762d70d7b59e69ac48c3f54d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdterrascan"
  end

  test do
    (testpath"ami.tf").write <<~EOS
      resource "aws_ami" "example" {
        name                = "terraform-example"
        virtualization_type = "hvm"
        root_device_name    = "devxvda"

        ebs_block_device {
          device_name = "devxvda"
          snapshot_id = "snap-xxxxxxxx"
          volume_size = 8
        }
      }
    EOS

    expected = <<~EOS
      \tViolated Policies   :\t0
      \tLow                 :\t0
      \tMedium              :\t0
      \tHigh                :\t0
    EOS

    output = shell_output("#{bin}terrascan scan -f #{testpath}ami.tf -t aws")
    assert_match expected, output
    assert_match(Policies Validated\s+:\s+\d+, output)
  end
end