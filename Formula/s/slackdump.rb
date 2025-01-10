class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv3.0.2.tar.gz"
  sha256 "f47eae0ec4d377d13f0feca449d1177fb655e182b736383c4c806ee97af28125"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5176fb9a957f27e8b24ec689d345f958341263b8f5d44450337b47a50e1150ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5176fb9a957f27e8b24ec689d345f958341263b8f5d44450337b47a50e1150ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5176fb9a957f27e8b24ec689d345f958341263b8f5d44450337b47a50e1150ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "5322eefe45e42d23339b216ea87e874e997353afa81222fe6df1224a7024d0c4"
    sha256 cellar: :any_skip_relocation, ventura:       "5322eefe45e42d23339b216ea87e874e997353afa81222fe6df1224a7024d0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1013b21e098353406f1918dad105358b903ccfc0ee4b481ea0315769d0e6cf9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdslackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}slackdump version")

    output = shell_output("#{bin}slackdump workspace list 2>&1", 9)
    assert_match "ERROR 009 (User Error): no authenticated workspaces", output
  end
end