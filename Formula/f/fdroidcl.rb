class Fdroidcl < Formula
  desc "F-Droid desktop client"
  homepage "https:github.commvdanfdroidcl"
  url "https:github.commvdanfdroidclarchiverefstagsv0.7.0.tar.gz"
  sha256 "4dbbb2106c23564a19cdde912d3f06cd258f02eccd6382a0532ef64e7e61f2fd"
  license "BSD-3-Clause"
  head "https:github.commvdanfdroidcl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "efa31b785a7f370e90560acc8feed5dc208053fa239064062b6dc09a42749c4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29143b7cc90ec131c4d1be6fcdc86f52478da32be90174e61a3a84b3bc8a09f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6439e615b6b2a8215cb52dddceccf338311592fb196a1c6d44f2aa5c266e5e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6439e615b6b2a8215cb52dddceccf338311592fb196a1c6d44f2aa5c266e5e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6439e615b6b2a8215cb52dddceccf338311592fb196a1c6d44f2aa5c266e5e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e6510e3caebb3237f50ae932dfe562b13b2245777205acb289b5e603f89356a"
    sha256 cellar: :any_skip_relocation, ventura:        "aab9b2028e64b0c1a6720227648e3cb5c2b4bb66356a826b325fb9189808d7ef"
    sha256 cellar: :any_skip_relocation, monterey:       "aab9b2028e64b0c1a6720227648e3cb5c2b4bb66356a826b325fb9189808d7ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "aab9b2028e64b0c1a6720227648e3cb5c2b4bb66356a826b325fb9189808d7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e51256959812a67ce1ff4b6a9169e7e72cd07e3ef548d6199848caa3a6ce888d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "f-droid.orgrepo", shell_output("#{bin}fdroidcl update")

    list = <<~EOS
      Connectivity
      Development
      Games
      Graphics
      Internet
      Money
      Multimedia
      Navigation
      Phone & SMS
      Reading
      Science & Education
      Security
      Sports & Health
      System
      Theming
      Time
      Writing
    EOS
    assert_equal list, shell_output("#{bin}fdroidcl list categories")
    assert_match version.to_s, shell_output("#{bin}fdroidcl version")
  end
end