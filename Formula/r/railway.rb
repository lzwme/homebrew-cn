class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.17.9.tar.gz"
  sha256 "27f09e8f2338b9c8544aa4f782232dd4a46f7929c508acfd9a497ea3422d207e"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1573393bd8f59eff3ef3ed9ae4869d7199f84e668b40f646e185aa8beab0d981"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f109f42bab1fb6e63a68c28a71498070c53c0854cc7225349a991704d7917b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91b2d0e03ad6591c2e31430917c06db86821736bbbafe24f3c5fd4c190005056"
    sha256 cellar: :any_skip_relocation, sonoma:        "284a0037b2ee7abe55c23245865494cefcc6a5e65dfccb9a8106e6e04a2c84b1"
    sha256 cellar: :any_skip_relocation, ventura:       "7e168c94183b25c371477191d379010cbe7847b58d06cf7aa63d146e61ab8493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5569d8e711cd93fd467ffcccd7f92efc3abfe9b86c6d79ead753dc1726835ff"
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