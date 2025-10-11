class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora/"
  url "https://ghfast.top/https://github.com/xuri/aurora/archive/refs/tags/2.2.tar.gz"
  sha256 "90ac08b7c960aa24ee0c8e60759e398ef205f5b48c2293dd81d9c2f17b24ca42"
  license "MIT"
  head "https://github.com/xuri/aurora.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d851326e81898d1d2e48168b6bfdfaa7a9073361543e2fca53be0d0bb28a27ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4cb522a01c06cf788476d58b83b367c4c753f7fc6ced76b18881586eefd8c188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e21aa44a64a8a48a4a0ac332f5069076fcfe8f3bd29a9ae9a2c5a6c6ab966cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f466ea097843bef81d5d4ad254e51d06bc2cc33be76f7fcb900a65e6a513fe3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5187558579ceb4884f08f91855d393bb0f0b79b7ac5a4ff1abc1cdc43a780006"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "798b63da7188da92582ffde96fed8f3407add006f2db88a610cb4aacda1c5b89"
    sha256 cellar: :any_skip_relocation, sonoma:         "6069583d481b3409513c421031a0f57ec2cc32f0c312f65043630e477d683e99"
    sha256 cellar: :any_skip_relocation, ventura:        "93ceeb44e164b13e4c6c4711a3ddaee49451691bf7e19fc0f49de1ad47d453c5"
    sha256 cellar: :any_skip_relocation, monterey:       "fc1e371ec7afa848b85dd45424209ed1d9da85985e9cf5cc21a6ae46071847bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "714b7116c80107b6ffb0f5b8abba41ae5aa88708fe688e61144ca3a636b7fc4f"
    sha256 cellar: :any_skip_relocation, catalina:       "f3b45006b5b5c6f15166d11d1a740fb14f3b22c1d64b3b64397ed2958e9c882d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8077df23766d9926fc9b8948ce0ea1861465dad40c42a3f7576a0599ce5f08b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c045ae045444b0e5f6ad993b2d30697908b1925132ea47fe2d25b46e729a760c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end