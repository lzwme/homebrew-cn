class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://ghproxy.com/https://github.com/gittuf/gittuf/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "001e34eef001a617a5658f0a77ab00278d8a9c6f5f2de74f65ea3bc919422417"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e14f5d3738fe2dbbafa5f15f3ac25296a176186913b429e23d8b2d3dfe070cd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "239404d9047a810c5a9fc66840bc23e362b7a0c3c0afcf4a423b447b51a7a8f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6beeb52d2f1b53566384ab7718cf33c979dc934eed7741f18a9bf0a97604d8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "519ad6c10cd8ca65ce0fe3b90f77ff6b2780a52c4f0f9295dba7e1d3e47209c9"
    sha256 cellar: :any_skip_relocation, ventura:        "a32c7d1aff08c0a7da5ac21cbe6d9c57cc8102f2b6b44417f102e844bc57aae9"
    sha256 cellar: :any_skip_relocation, monterey:       "a3962c0eee0ba15235fe03d3feeb7208d54f49030372c543da384a95ca740c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb7aa1476b2b87678eb409b8a44f563a8a3b3ccbfa6fc13ef775e1956fe28027"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gittuf", "completion")
  end

  test do
    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match "\"signing-key\" not set", output

    output = shell_output("#{bin}/gittuf rsl remote check brewtest 2>&1", 1)
    assert_match "Error: repository does not exist", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end