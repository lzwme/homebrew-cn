class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.8.0.tar.gz"
  sha256 "a2a6dcfcfe646fa40959edc056ffdb97df2119926c3e60ad9e8f131fcbc96e90"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6120eaafeac28c7b2211c1b6f453f80b05c5dc7486d527607b76afdca36ecad8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "266f9206ec605cd56b391c6add25f57fc5df3127026d0cf1849c286668710efc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c0d47c234db463903ff678ccd11c479903b96d8d72a47d051d33c15182a5792"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cc37a42a7a949b67a24f237af1c82e26d2bbff966ea472d482c26fa330c77c6"
    sha256 cellar: :any_skip_relocation, ventura:        "009a94a8e3d914ea272fd392365df2f1079493a1a499259c9c736d992c005feb"
    sha256 cellar: :any_skip_relocation, monterey:       "3f9be8a4cc6e529f18cf72f40cac4ca81965a796873d8a2882da415bb07add94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "676814ee78ca1273f61a8c7fe0f22003572ae52e2db84d43873f1d167eaac58e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end