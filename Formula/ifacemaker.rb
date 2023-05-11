class Ifacemaker < Formula
  desc "Generate interfaces from structure methods"
  homepage "https://github.com/vburenin/ifacemaker"
  url "https://ghproxy.com/https://github.com/vburenin/ifacemaker/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "3bbe9d742995ca5804da15f0f01ed85ff5d68b6b3e22b04c1491492eb703aa54"
  license "Apache-2.0"
  head "https://github.com/vburenin/ifacemaker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87408de1f42dcab543551dd12efc8f8616779595ec9d001bac8d5e41272b5fcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87408de1f42dcab543551dd12efc8f8616779595ec9d001bac8d5e41272b5fcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87408de1f42dcab543551dd12efc8f8616779595ec9d001bac8d5e41272b5fcf"
    sha256 cellar: :any_skip_relocation, ventura:        "6e5a0afe3650cf97a62be0c43e830b786c769430dce3cdbe51e7abc4f157861c"
    sha256 cellar: :any_skip_relocation, monterey:       "6e5a0afe3650cf97a62be0c43e830b786c769430dce3cdbe51e7abc4f157861c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e5a0afe3650cf97a62be0c43e830b786c769430dce3cdbe51e7abc4f157861c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e76f770fa867389cf4b882db3ba239a4a35e0902ee5137d2860e975964fb0317"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"human.go").write <<~EOS
      package main

      type Human struct {
        name string
      }

      // Returns the name of our Human.
      func (h *Human) GetName() string {
        return h.name
      }
    EOS

    output = shell_output("#{bin}/ifacemaker -f human.go -s Human -i HumanIface -p humantest " \
                          "-y \"HumanIface makes human interaction easy\"" \
                          "-c \"DONT EDIT: Auto generated\"")
    assert_match "type HumanIface interface", output
  end
end