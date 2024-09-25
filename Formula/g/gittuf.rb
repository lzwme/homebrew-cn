class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https:gittuf.dev"
  url "https:github.comgittufgittufarchiverefstagsv0.6.0.tar.gz"
  sha256 "5cf3616edcfe4158873d06fbc0cd220271031da9827a955ffb431b6e7d517eee"
  license "Apache-2.0"
  head "https:github.comgittufgittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "419423930dd3b0b7ce109cf4e737539a19f0249d24572e8fe9e03c4d441ffd04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "419423930dd3b0b7ce109cf4e737539a19f0249d24572e8fe9e03c4d441ffd04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "419423930dd3b0b7ce109cf4e737539a19f0249d24572e8fe9e03c4d441ffd04"
    sha256 cellar: :any_skip_relocation, sonoma:        "c51f5fe015c0de2c98afa42b6daa688c40bf4426ee2b32cbc60cb76587e6501e"
    sha256 cellar: :any_skip_relocation, ventura:       "4f428de0086b9e0a1642b749be6d2b338a8453e4169af4275d1029924b5640b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5569bcec0c4be83e8374e86ed09674591ea927533d7b024d13774219c38ee124"
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