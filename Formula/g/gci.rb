class Gci < Formula
  desc "Control Golang package import order and make it always deterministic"
  homepage "https:github.comdaixiang0gci"
  url "https:github.comdaixiang0gciarchiverefstagsv0.13.5.tar.gz"
  sha256 "1429a8486ea4b2b58ce7c507823c36239d88fc277c1229323858d1c9554767ce"
  license "BSD-3-Clause"
  head "https:github.comdaixiang0gci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e359d43f6e9493681f2b5b71d130dd402ad4caa4e367ca155ecc2b293b60403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e359d43f6e9493681f2b5b71d130dd402ad4caa4e367ca155ecc2b293b60403"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e359d43f6e9493681f2b5b71d130dd402ad4caa4e367ca155ecc2b293b60403"
    sha256 cellar: :any_skip_relocation, sonoma:        "99e6d31ed6740799d948cd3710a7ed07f805bc66e82b3563a626242c9f3a4db0"
    sha256 cellar: :any_skip_relocation, ventura:       "99e6d31ed6740799d948cd3710a7ed07f805bc66e82b3563a626242c9f3a4db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "152bf0214bf70dbc6fff4b812f93ca75a83923937b4ea605084933c93cebfd1f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"main.go").write <<~GO
      package main
      import (
        "golang.orgxtools"

        "fmt"

        "github.comdaixiang0gci"
      )
    GO
    system bin"gci", "write", testpath"main.go"

    assert_equal <<~GO, (testpath"main.go").read
      package main

      import (
      \t"fmt"

      \t"github.comdaixiang0gci"
      \t"golang.orgxtools"
      )
    GO

    # currently the version is off, see upstream pr, https:github.comdaixiang0gcipull218
    # assert_match version.to_s, shell_output("#{bin}gci --version")
  end
end