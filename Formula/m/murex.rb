class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v5.2.7610.tar.gz"
  sha256 "6f90460dd31e1f882189a697488522eae6005c748b3194c403acfd617fe4041b"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48865b87d2661c2b2903831d0a290a835f8fe4615273c650364d6d57021b6bfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f88e83e9211e0d7dd3ad38e52fc134643c7bd67b679f2f03a05cfa001b7623d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccf9d69d26f9794501cb84e87706cb9ed2f5756d57e16219813f35ac4d08674c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c51ae48e56e226a5d38a4b9b7e9882ae165844a34b97dbef86927258df032eb2"
    sha256 cellar: :any_skip_relocation, ventura:        "3409c6c4ab7b91a2c60d63c29acea76c5e273993ea5d3a74afcbe689b0ab621f"
    sha256 cellar: :any_skip_relocation, monterey:       "afdf491857c607e4fd40189510f723b0aa2aa805637939b8656d0a5bce6bb132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6beb3095f1f012d9489ff6f67595e190fdbbe2d0ce6132bb46b3b6f9724635a1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end