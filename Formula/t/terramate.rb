class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.10.2.tar.gz"
  sha256 "ed51014d6d6ccc3910d10ed1a25223c1050c573b89dc9fdef1d7bd1b3dc9d710"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7694517d7ebf544f5b54ff932a9c619ae018e3c3513ef250e5501bd63391a5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7694517d7ebf544f5b54ff932a9c619ae018e3c3513ef250e5501bd63391a5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7694517d7ebf544f5b54ff932a9c619ae018e3c3513ef250e5501bd63391a5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9eeaf1421b0665e99496381f5d0622f837cb67e2419c60edec77ce1516814116"
    sha256 cellar: :any_skip_relocation, ventura:        "9eeaf1421b0665e99496381f5d0622f837cb67e2419c60edec77ce1516814116"
    sha256 cellar: :any_skip_relocation, monterey:       "9eeaf1421b0665e99496381f5d0622f837cb67e2419c60edec77ce1516814116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da08d868342ef3cd2582d9a737cca60ebb851bfcdead4ed37334ed5f39f82c3"
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