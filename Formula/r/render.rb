class Render < Formula
  desc "Command-line interface for Render"
  homepage "https:github.comrender-osscli"
  url "https:github.comrender-osscliarchiverefstagsv2.0.0.tar.gz"
  sha256 "a7bcc78fd4d38df7a19fcfcd3958dc89ded4353c12b5ed695cd215c6998c9926"
  license "Apache-2.0"
  head "https:github.comrender-osscli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "681dddef0b20697c1913c74aea32849ab4764d08d0c77d1c7380348b288accf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "681dddef0b20697c1913c74aea32849ab4764d08d0c77d1c7380348b288accf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "681dddef0b20697c1913c74aea32849ab4764d08d0c77d1c7380348b288accf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "135115371cc49b22b825566d5e4ad40f3f46a3d302a22ae8e403844cb1cc8bac"
    sha256 cellar: :any_skip_relocation, ventura:       "135115371cc49b22b825566d5e4ad40f3f46a3d302a22ae8e403844cb1cc8bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6304d7700a199f1684d339d7dfeecd67949a86373fcaed0b6b585437fe3a29ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comrenderincclipkgcfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    error_msg = "Error: run `render login` to authenticate"
    assert_match error_msg, shell_output("#{bin}render services -o json 2>&1", 1)
  end
end