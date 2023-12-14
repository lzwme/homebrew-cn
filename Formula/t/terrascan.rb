class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://ghproxy.com/https://github.com/tenable/terrascan/archive/refs/tags/v1.18.6.tar.gz"
  sha256 "be35828d6998007c9892d4f7df9a2958921f5e36af8f1eadb0528cf6680ac225"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c0fd390d15908e719348a7c9622a29a489442c40ef52481ec38fcc8ea138fa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ded288014d7184052b8550a42501ea1e1d348f08fb576265f03a11e7063be46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74686baed1fded39b4e1d6a7321c33f09f1ab89131c1fa283fdd90369804011c"
    sha256 cellar: :any_skip_relocation, sonoma:         "48ca762b8da51ab6ba68df7b58014e4a1466502bb95f55306e294d36f3d1e55c"
    sha256 cellar: :any_skip_relocation, ventura:        "db4f06988745691ab9aaf1530bd5a40f8acf966929a0c0957c1090cbe3a04057"
    sha256 cellar: :any_skip_relocation, monterey:       "6cc3279987e451563c6a86d0b88cd9b9e0bf277aa17afdae0951e90c9d4ab0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6780956378ef7a0149a32d8d48ac4be023573532031e5beb238a6733481f633a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terrascan"
  end

  test do
    (testpath/"ami.tf").write <<~EOS
      resource "aws_ami" "example" {
        name                = "terraform-example"
        virtualization_type = "hvm"
        root_device_name    = "/dev/xvda"

        ebs_block_device {
          device_name = "/dev/xvda"
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

    output = shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")
    assert_match expected, output
    assert_match(/Policies Validated\s+:\s+\d+/, output)
  end
end