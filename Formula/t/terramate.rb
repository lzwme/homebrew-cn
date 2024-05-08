class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.8.3.tar.gz"
  sha256 "aad65ecaad3c708837b17a23a6e89d7a93079be70c4384afea4e1f9134093784"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "981a62f83c170b1e33593357d3d04a09bc1e59ed91a49800d8a00419a7e4ffa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fc91bb65ab89d49292c31dad0ad1e02e0fb78cced01b935bb49bde5d602608c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0a21f3aab5a4765ad03108130ed384a0fb9f833ea24fc7992d114b968dbd629"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc09bc2e66d39458128962a539f6a31579b2005ea9941523cbc5e077827decb9"
    sha256 cellar: :any_skip_relocation, ventura:        "ba6a526a3879d8634f565aa9d71b8b8912b931a7c6b85bbc83d13bb671601fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "c1b1a17ddcea5077d554b9658faa9de16a0b4ec1353135c1283ee419142c0b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e685ee83cc705edcba38137d5196100122c1c8cb1a53aa3de6344dce85d510d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end