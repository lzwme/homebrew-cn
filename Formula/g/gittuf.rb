class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://ghfast.top/https://github.com/gittuf/gittuf/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "ff82ae54d89247cd296094f6a7c3d848309bd6966de4a3c588c0f47f67225849"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58643a531272425fae61dd138492c2f5a5da611cfa1f1675854e6665bd358aab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58643a531272425fae61dd138492c2f5a5da611cfa1f1675854e6665bd358aab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58643a531272425fae61dd138492c2f5a5da611cfa1f1675854e6665bd358aab"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c962440aba4f18695dc4cf2ccf9698924e936d6162e245ce769a01347910126"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a06d79f36e7f4e1a391e3e7394ff253f436499fb0b59e97a19ba9aa9c9c049b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc36cc56b91322a0a6a7e3f8984e67ddeb933bfd2a5477de914f6789da942868"
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