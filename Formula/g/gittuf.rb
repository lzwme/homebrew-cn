class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https:gittuf.dev"
  url "https:github.comgittufgittufarchiverefstagsv0.6.1.tar.gz"
  sha256 "1e72104908ecde4be2a7261c7e290938d1e39117e3c2806642c0c07509f86c72"
  license "Apache-2.0"
  head "https:github.comgittufgittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "398a691028e1405b9cdd693227c5aeaa4c9a5301c4f88eafa2259b4639b68310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "398a691028e1405b9cdd693227c5aeaa4c9a5301c4f88eafa2259b4639b68310"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "398a691028e1405b9cdd693227c5aeaa4c9a5301c4f88eafa2259b4639b68310"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b91be8b4ba75beca025f0733136c0bdce20cb42f2da6a83f47a46c4a9b9ffc2"
    sha256 cellar: :any_skip_relocation, ventura:       "27723ba4425234f8d612c6a2de7fbcaab018774febdd74402272ad2bb1bf0627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a71868ef35ffeb2da60cab7a3e05ceeaa640e804aae658f100e2cecced0f1962"
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