class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv0.11.1.tar.gz"
  sha256 "55c5e223d8746d756e811ca602ea73e92ed44f844b5520ec744709adefd1643a"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9edf194dcd1100396a357382c903b47e0c0e11c5c2f5c450aa9df4f1105b8199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e82eccc781b003c5aee634d7b33947c55fb9d552a8535d1e8b524f346efa8caa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb8ba246ae0761e66510e5f6f77f28ce259709032d5bd94f75b2272e30b1780d"
    sha256 cellar: :any_skip_relocation, sonoma:        "56bbb9910c980e8bec5dddcafbd10d5684afe61fa4a2b99dcac2d03745b95309"
    sha256 cellar: :any_skip_relocation, ventura:       "e29dae8993ac75806368af520b7edd9fc2ba6f337832e76f6e1487d51d8a1d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71444284b8a962069b4b2248d09a7fc3d71b701086f230be5526bb2f9d86cfaa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end