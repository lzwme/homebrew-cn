class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://ghfast.top/https://github.com/gittuf/gittuf/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "9a9e4578b7246ba3051329c7f780ba58208defbb0c157a2b353d889d1057c633"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e09513abecbd1ffe1a71e0ae1445dbca4fcd079c7b01dfff81d53aed3d6ecc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e09513abecbd1ffe1a71e0ae1445dbca4fcd079c7b01dfff81d53aed3d6ecc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e09513abecbd1ffe1a71e0ae1445dbca4fcd079c7b01dfff81d53aed3d6ecc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "854bc48c4e811614d1bff212df4e513e496a337c05b9e463eb4dd7fc0f5917a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f6bf02fadce3597bef198b92def02902f580c6f7e627d1e2a7e5b420218de52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a61aa84c0e5238451165c9c55aca2111c72af2ba6ddd77895aa898d71441118"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-remote-gittuf"), "./internal/git-remote-gittuf"

    generate_completions_from_executable(bin/"gittuf", shell_parameter_format: :cobra)
  end

  test do
    system "git", "init"

    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match(
      /Error: (required flag "signing-key" not set|signing key not specified in Git configuration)/,
      output,
    )

    output = shell_output("#{bin}/gittuf sync 2>&1", 1)
    assert_match "Error:", output
    assert_match(/(unable to identify git directory for repository|No such remote 'origin')/, output)

    output = shell_output("#{bin}/git-remote-gittuf 2>&1", 1)
    assert_match "usage: #{bin}/git-remote-gittuf <remote-name> <url>", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end