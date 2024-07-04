class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https:gittuf.dev"
  url "https:github.comgittufgittufarchiverefstagsv0.5.1.tar.gz"
  sha256 "6d598fd10d37dc2dd011042277da9347be6c65dd2fafc2c5c5f1af07b34e2430"
  license "Apache-2.0"
  head "https:github.comgittufgittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c2f861bdc91f3e0616c74eb74445d99e48ae763123ba61bc5e96a8ec9c764ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bc9a2ca5fc614b44eb62e2766639386fbeb4480c18b6b1a6c9dbb1347a6abe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dd0d9d2cc566f5dbff7f4961322736979968bd3253e6feac1b48ac5f7a398e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d4cbb4aefd39513c29e27c1cd05a3b92f068d5f39fdc34f920eb0b87ebae950"
    sha256 cellar: :any_skip_relocation, ventura:        "c3175fb2d9fd102b7cf74200bbb812a0333788c095e211e29b418363c9940e2e"
    sha256 cellar: :any_skip_relocation, monterey:       "9da58e8a71a10c7b90de41d86c606f23019fe687a98f7e2e047e17c750e28650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e2a08dd9c2a8ead2d8f5d66605c7a070f1644ef0ced62a7f2d7868ea89c37ff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comgittufgittufinternalversion.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"gittuf", "completion")
  end

  test do
    output = shell_output("#{bin}gittuf policy init 2>&1", 1)
    assert_match "Error: required flag \"signing-key\" not set", output unless OS.linux?

    output = shell_output("#{bin}gittuf rsl remote check brewtest 2>&1", 1)
    assert_match "Error: unable to identify GIT_DIR", output

    assert_match version.to_s, shell_output("#{bin}gittuf version")
  end
end