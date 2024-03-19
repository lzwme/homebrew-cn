class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.23.8.tar.gz"
  sha256 "795efdd4e836e4249aad47daeef56915f1b9b65d7b9f8978ee350f22bc489176"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11dac5989f2e478344ea59311ec2bd86022e13abedc372c20a54521bc68ebe8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11dac5989f2e478344ea59311ec2bd86022e13abedc372c20a54521bc68ebe8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11dac5989f2e478344ea59311ec2bd86022e13abedc372c20a54521bc68ebe8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "57fe0d1d82af15e50692a561590bfedddcc90aa4e9b8076bcb55ff95868c0d34"
    sha256 cellar: :any_skip_relocation, ventura:        "57fe0d1d82af15e50692a561590bfedddcc90aa4e9b8076bcb55ff95868c0d34"
    sha256 cellar: :any_skip_relocation, monterey:       "57fe0d1d82af15e50692a561590bfedddcc90aa4e9b8076bcb55ff95868c0d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57d582777e9ea5520429f83e070d5d9ae3650ce7ebe3c101db924c1a0a3a33a0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end