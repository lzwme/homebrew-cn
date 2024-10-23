class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.11.0.tar.gz"
  sha256 "18cb41ae505793c1699fa98f052325c82f967ce2ddf7b5b3bada60c4076b41e5"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7bff1e9932fc5722b31adb8796c0fb15bf49128efed12a539f5f8a9f3e7b62c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7bff1e9932fc5722b31adb8796c0fb15bf49128efed12a539f5f8a9f3e7b62c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7bff1e9932fc5722b31adb8796c0fb15bf49128efed12a539f5f8a9f3e7b62c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ed989488ccdae6bdf0c3dac8e2f403203e4d3dd3b727922a0c26c78d03be198"
    sha256 cellar: :any_skip_relocation, ventura:       "8ed989488ccdae6bdf0c3dac8e2f403203e4d3dd3b727922a0c26c78d03be198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "064cc7135b1494d26b2f6aebe0cb091c308c566afc80a08f51420a78ad85092b"
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