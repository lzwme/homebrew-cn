class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.19.0.tar.gz"
  sha256 "34bbd190b651a3e12aea9eb4b7963891c8e44a30c80e57170d697332b57a1d25"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10c6d71c38121f002267dfbb728f167e68969b24fe99fe27fda5f98599a28124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d40496a0d192dcb10f69f76e1ed69b630bc0aa6cbf9c154ed837c08d15ef578a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "008a2f07e99a6beaa6081b13c718c7ff07bac2b44b84c69341ef87d8e0d5c588"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dc60dd5acbecfe492d5c00a95206df82b2b4375292a24dfc523096bd01b5740"
    sha256 cellar: :any_skip_relocation, ventura:       "ce982247a056dad7edc8b57dd311a506f0beb9ed7f6aca3ba50fa12881b5a4c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4faa0fb33338bb045660a2c2b6dfec628bc1c8fefab706de791eb5725824ddd3"
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