class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https:github.comyorukotsuperfile"
  url "https:github.comyorukotsuperfilearchiverefstagsv1.1.7.tar.gz"
  sha256 "ef632479edd6db89825589f7c52c2c46af92da0f5622b5b315e7bf6a600150cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "504e7d78c2b3c1d033bdc3d7a2d9b0d699eb409727fbae3738ceeac89b600796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "700c92fcd7d5fb0124743f82172760abb834907df15229d7994389a3d66b5cf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20754f38a4fa99a84fd8ac27d2c85f25ba25a1f854e66371ad457b7502e280e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6ae2286705c320454963b6caf48f727120e760d8a233f7d65e61f35ed0418c1"
    sha256 cellar: :any_skip_relocation, ventura:       "b76f1bdec76b56a40d78723663b7edded4ba5c2c7d206cc30080e16bdb35608d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "510a49c024b68005069ed0e49cdceca6e937ca206b5ba6eedd42034b1ca82ddf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}spf -v")
  end
end