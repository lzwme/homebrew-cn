class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https:github.comvariadiconoti"
  url "https:github.comvariadiconotiarchiverefstags3.8.0.tar.gz"
  sha256 "b637b4b4e5eb10b3ea2c5b2cf0fbd1904ab8fd26eaec4b911f4ce2db3ab881a2"
  license "MIT"
  head "https:github.comvariadiconoti.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7373f99acea5809bcc89237de6cfe9b869fb194603f9ffa69d90c6a01ae60cf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6990ad34fe5bc000e70e99dba5d95ce91d21de18bc4aef2138af3140981da26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9879896973d077b35c59c8485a875f45be367a68879879ba58c5ce643fa1576f"
    sha256 cellar: :any_skip_relocation, sonoma:        "994c5a03f74ad08b6dedf050d601701b2a72e58b9dbc078e0cf185da984a75ab"
    sha256 cellar: :any_skip_relocation, ventura:       "ab62225e51f6f38ce4ffae1addbd91e5536dfc47ee86e9325c867030709b758f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823432578796ba95f2e4b9dab197cb978935159e7282e83738778a3f492259da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comvariadiconotiinternalcommand.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "cmdnotimain.go"
    man1.install "docsmandistnoti.1"
    man5.install "docsmandistnoti.yaml.5"
  end

  test do
    assert_match "noti version #{version}", shell_output("#{bin}noti --version").chomp
    system bin"noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end