class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://github.com/budimanjojo/talhelper"
  url "https://ghproxy.com/https://github.com/budimanjojo/talhelper/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "916f260de8642c1f247b9308eb0619d90bf6d23e73d60be1d2dac9cd99fe2160"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a4a803f592918ec85d98f4741605e2843fff6e799edc008b2bfbae78de47915"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f1186d983d706746011f75629bc18e1e5fc9b86b9f91bd77d068a8f1896879f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02521bc30e357839ef1c8b453745ab44a9e7fda283a6df9e22b33c2690aeb955"
    sha256 cellar: :any_skip_relocation, sonoma:         "d312bd5310865fa1a9d824b5ed28a4e27dc4a2b3d040e7d9ab503b9461b317cd"
    sha256 cellar: :any_skip_relocation, ventura:        "bf0cbf19f791212090c23b98d2a7b7f76f1c01ce99a27f06228f3ad6562d422f"
    sha256 cellar: :any_skip_relocation, monterey:       "7533c1ff8a48eeee65fec4f81df72329dcacfeb4dce4f3b405afa327012ec89f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b82939a22ac4adf5a75829e846ed246ebf38d4c8f103b6cab8bb7484b72089f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to decrypt/read env file talenv.yaml", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end