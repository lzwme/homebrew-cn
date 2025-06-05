class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https:steampipe.io"
  url "https:github.comturbotsteampipearchiverefstagsv1.1.4.tar.gz"
  sha256 "95c2b6518f9fa62b4082e300b3382b68d5bbe2444fa24cdfbce4c314626e0a62"
  license "AGPL-3.0-only"
  head "https:github.comturbotsteampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7be0e36b2609eeca63f3693b2018d049d01d5064c5f546fd71f392dba2e803e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e66624b7e948e0387d9d82f530993865a63ba9228867c687bdf577a0b1e373"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89644ef75a320109f3465087fd129daab7d24d4656d490ac6bc42b7ac8e89352"
    sha256 cellar: :any_skip_relocation, sonoma:        "dccb8e97ceb8fbddddfc831bb751e08a3c5450841aaccdd66357b4d103a3e329"
    sha256 cellar: :any_skip_relocation, ventura:       "94cb4fa6cb55fced81217bda31fc27a720a527a2131c8d66fd05dd623e334f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32c26f8f34c26b16dfc8f3b06adcf17f13d81d77158b6c2ea592b4bc2076e017"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin"steampipe service status 2>&1", 255)
      assert_match "Error: could not create logs directory", output
    else # Linux
      output = shell_output(bin"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin"steampipe --version")
  end
end