class Render < Formula
  desc "Command-line interface for Render"
  homepage "https:render.comdocscli"
  url "https:github.comrender-osscliarchiverefstagsv2.0.0.tar.gz"
  sha256 "a7bcc78fd4d38df7a19fcfcd3958dc89ded4353c12b5ed695cd215c6998c9926"
  license "Apache-2.0"
  head "https:github.comrender-osscli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e96e67b0026c03994984904c9f04b34bfbc1618f00cf2620c42698763b7bb49a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e96e67b0026c03994984904c9f04b34bfbc1618f00cf2620c42698763b7bb49a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e96e67b0026c03994984904c9f04b34bfbc1618f00cf2620c42698763b7bb49a"
    sha256 cellar: :any_skip_relocation, sonoma:        "668d6be46967a7a95f0fe53479f86ebebda33997781fd65f92e0200599c0fe73"
    sha256 cellar: :any_skip_relocation, ventura:       "668d6be46967a7a95f0fe53479f86ebebda33997781fd65f92e0200599c0fe73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bdaed3e1e32be9841660912c4bf07003306532d1952957b2551c821f72017c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comrender-ossclipkgcfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    error_msg = "Error: run `render login` to authenticate"
    assert_match error_msg, shell_output("#{bin}render services -o json 2>&1", 1)
  end
end